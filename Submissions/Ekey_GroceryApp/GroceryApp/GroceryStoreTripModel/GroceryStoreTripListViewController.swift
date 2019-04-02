//
//  GroceryTripListViewController.swift
//  GroceryApp
//
//  Created by johnekey on 3/31/19.
//

import UIKit

class GroceryStoreTripListViewController: UIViewController {

  //  let shopperModel = Shopper(persistence: GroceryListPersistence())
    
    @IBOutlet weak var budgetValue: UILabel!
    
    @IBOutlet weak var totalCostValue: UILabel!
    
    @IBOutlet weak var balanceValue: UILabel!
    
    
    let gstModel = GroceryStoreTrip(persistence: GroceryListPersistence(),
                                    budget: 100.00,
                                    groceryList: [ GroceryItem( "Milk", 1, 2.50),                                                                                   GroceryItem( "Yogurt",  1,  2.50),                                                                                                                 GroceryItem( "Apples",  4),                                                                                                                ], taxRate: 0.10)
    
    @IBOutlet weak var groceryStoreTripTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groceryStoreTripTableView.dataSource = self
        groceryStoreTripTableView.delegate = self
        
        // let the groceryStoreTripTableView listen for the model's delegate
        gstModel.delegate = self
        
        budgetValue.text = "100.00"

        do {
            totalCostValue.text = String(try gstModel.calculateTtlCost())
            balanceValue.text = String(try gstModel.calculateBalance())
            _ = try gstModel.checkOut()
        } catch {

        }
    }
    

    @IBAction func addButtonTapped(_ sender: UIButton) {
        // call the segue - AddItemSegueID
        performSegue(withIdentifier: "AddItemSegueID", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AddToCartViewController else {
            return
        }
        // pass the REAL unique ptr to the model to the destination view controller -
        destination.gstModel = gstModel
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
    }
}

// When the user scrolls off the screen the cell gets dequeued to conserve memor
extension GroceryStoreTripListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gstModel.myCart.count
    }


    // Custom Table

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = groceryStoreTripTableView.dequeueReusableCell(withIdentifier: "gstCellID", for: indexPath) as! GSTTableViewCell

        // var groceryItem: GroceryItem?

        do {
            let groceryItem = try gstModel.getGroceryCartItem(index: indexPath.row)
            // item quantity
            let costString = String(format:"%.1f", groceryItem!.cost ?? 0.0)
            var ttlCost = 0.0
            if groceryItem!.cost != nil && groceryItem!.quantity != 0 {
                ttlCost = groceryItem!.cost! * Double(groceryItem!.quantity)
            }
            let ttlCostString = String(format:"%.1f", ttlCost)
            cell.ttlCostTextField?.text = ttlCostString
            // item name

            cell.costTextField?.text  = costString
            cell.qtyTextField?.text  = String(groceryItem!.quantity)
            cell.nameTextField?.text  = groceryItem?.name

        } catch {

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
    
    }
}



