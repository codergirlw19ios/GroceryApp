//
//  GroceryTripListViewController.swift
//  GroceryApp
//
//  Created by johnekey on 3/31/19.
//

import UIKit

class GroceryStoreTripListViewController: UIViewController {

  //  let shopperModel = Shopper(persistence: GroceryListPersistence())
    
    @IBOutlet weak var addButton: UIButton!
    
    
    @IBOutlet weak var budgetValue: UILabel!
    
    @IBOutlet weak var totalCostValue: UILabel!
    
    @IBOutlet weak var balanceValue: UILabel!
    
    //var gstModel:  GroceryStoreTrip?
    
    let gstModel = GroceryStoreTrip(persistence: GroceryListPersistence(),
                                    budget: 100.00,
                                    groceryList: [ GroceryItem( "Milk", 1, 2.50),                                                                                   GroceryItem( "Yogurt",  1,  2.50),                                                                                                                 GroceryItem( "Apples",  4),                                                                                                                ], taxRate: 0.10)
    
    @IBOutlet weak var groceryStoreTripTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   addButton.isEnabled = false
        groceryStoreTripTableView.dataSource = self
        groceryStoreTripTableView.delegate = self
        
        // let the groceryStoreTripTableView listen for the model's delegate
        gstModel.delegate = self
        
        budgetValue.text = "100.0"

        calculateTotals()
    }
    

    @IBAction func addButtonTapped(_ sender: UIButton) {
        gstModel.actionModel.action = Action.Add
        gstModel.actionModel.row = 0
        // call the segue - AddItemSegueID
        performSegue(withIdentifier: "AddItemSegueID", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let destination = segue.destination as? AddToCartViewController else {
            return
        }
        
        // pass the REAL unique ptr to the model to the destination view controller
        destination.gstModel = gstModel
        
        // determine if I'm add or edit
//        let theSender = sender as? GroceryItem
//
//        if (theSender != nil)
//        {
//            destination.groceryItem = theSender!
//        }
        
 
        
//        switch(segue.identifier ?? "") {
//
//        case "AddItemSegueID":
//            print("Add Item")
//        case "EditItemSegueID":
//            print("EditItem")
//        default:
//            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "No Identifier")")
//        }
        
        
    }
    
    func calculateTotals() {
        do {
            totalCostValue.text = String(try gstModel.calculateTtlCost())
            balanceValue.text = String(try gstModel.calculateBalance())
            _ = try gstModel.checkOut()
        } catch {
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension GroceryStoreTripListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // hanlde selecting a row for editing
        
        do {
            
            gstModel.actionModel.action = Action.Edit
            gstModel.actionModel.row = indexPath.row
            // call the segue - AddItemSegueID
            performSegue(withIdentifier: "AddItemSegueID", sender: nil)
            
        } catch {
            print(error)
        }
    }
    
}

// When the user scrolls off the screen the cell gets dequeued to conserve memor
extension GroceryStoreTripListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gstModel.myCart.count
    }


    // Custom Table
    // Handles displaying the information per cell for eaach row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = groceryStoreTripTableView.dequeueReusableCell(withIdentifier: "gstCellID", for: indexPath) as! GSTTableViewCell

        // var groceryItem: GroceryItem?

        do {
            let groceryItem = try gstModel.getGroceryCartItem(index: indexPath.row)
            // item quantity
             var ttlCost = 0.0
            if groceryItem!.cost != nil && groceryItem!.quantity != 0 {
                ttlCost = groceryItem!.cost ?? 0.0 * Double(groceryItem!.quantity)
            }
            let ttlCostString = String(format:"%.1f", ttlCost)
            cell.ttlCostTextField?.text = ttlCostString
            // item name

 //           cell.costTextField?.text  = String(format:"%.1f", groceryItem!.cost ?? 0.0)
            
            cell.costTextField?.text  = String(groceryItem!.cost ?? 0.0)
            cell.qtyTextField?.text  = String(groceryItem!.quantity)
            cell.nameTextField?.text  = groceryItem?.name

        } catch {
            print(error)
        }

        return cell
    }
}

// This viewController is listening for notifications from the GroceryStoreTripDelegate
// specifically the notification about dataUpdated
extension GroceryStoreTripListViewController : GroceryStoreTripDelegate {
    func dataUpdated() {
        groceryStoreTripTableView.reloadData()
        // or if you just need to do a section -- uses an animation which is prettier...
        // groceryListTableView.reloadSections(<#T##sections: IndexSet##IndexSet#>, with: <#T##UITableView.RowAnimation#>)
    
        // Since we updated the data, let's recalculate totals
        calculateTotals()
    }
}


extension  GroceryStoreTripListViewController : UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        // If code does not execute -- did I hook up the delegate???
        do {
            // Focus may have just left one object, however both need to be valid to enable the save
            if (textField == budgetValue ) {
                _ = try gstModel.validateDouble(doubleValue: textField.text)
                guard let dbl = Double(textField.text!) else {
                    throw(GroceryStoreTripError.nonIntegerValue)
                }
                if dbl > 0.0 {
                    addButton.isEnabled = true
                }
            }
        } catch {
            addButton.isEnabled = false
        }
        
        
        // return false means focus is retained on field
        return true
    }
}
