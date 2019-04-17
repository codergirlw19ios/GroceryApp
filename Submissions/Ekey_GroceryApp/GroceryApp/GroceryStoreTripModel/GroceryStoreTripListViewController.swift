//
//  GroceryTripListViewController.swift
//  GroceryApp
//
//  Created by johnekey on 3/31/19.
//

import UIKit

class GroceryStoreTripListViewController: UIViewController {

  //  let shopperModel = Shopper(persistence: GroceryListPersistence())
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var budgetValue: UITextField!
    @IBOutlet weak var taxRateValue: UITextField!
    @IBOutlet weak var totalCostValue: UITextField!
    @IBOutlet weak var balanceValue: UITextField!
    @IBOutlet weak var groceryStoreTripTableView: UITableView!
    var gstModel:  GroceryStoreTrip?
    
    private var dismissKeyboardGesture: UITapGestureRecognizer?
    
//    let gstModel = GroceryStoreTrip(persistence: GroceryListPersistence(),
//                                    budget: 100.00,
//                                    groceryList: [ GroceryItem( "Milk", 1, 2.50),                                                                                   GroceryItem( "Yogurt",  1,  2.50),                                                                                                                 GroceryItem( "Apples",  4),                                                                                                                ], taxRate: 0.10)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.isEnabled = false
        groceryStoreTripTableView.dataSource = self
        groceryStoreTripTableView.delegate = self
        
        // let the groceryStoreTripTableView listen for the model's delegate  i.e.  GroceryStoreTripDelegate {
        gstModel?.delegate = self
        budgetValue.delegate = self
        taxRateValue.delegate = self
        budgetValue.text = Validation.currency(from: 0.0)
        budgetValue.becomeFirstResponder()
        
        totalCostValue.isEnabled = false
        balanceValue.isEnabled = false
        calculateTotals()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        // if there is no model, do not trigger segue; you cannot abort from prepare(for:sender:) so you have to stop the action here.
        guard gstModel != nil else { return }

        gstModel?.actionModel.action = Action.Add
        gstModel?.actionModel.row = 0
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
    }
    
    func generateModel(budget: Double, taxRate: Double) -> Bool {
        
        if (budget <= 0.0) {
            return false
        }
        
        if (gstModel == nil) {
            gstModel = GroceryStoreTrip(persistence: GroceryListPersistence(),
                                    budget: budget,
                                    groceryList: [ GroceryItem( "Milk", 1, 2.50),                                                                                                          GroceryItem( "Yogurt",  1,  2.50),                                                                                                                 GroceryItem( "Apples",  4),                                                                                                                ], taxRate: taxRate > 0.0 ? taxRate : 0.0)
       
        }
        
        addButton.isEnabled = true
        gstModel?.delegate = self
        //        populateTextViews()
        groceryStoreTripTableView.reloadData()
        view.layoutIfNeeded()
            
        
        
        return true
    }
    
    func calculateTotals() {
        do {
            taxRateValue.text = String(gstModel?.taxRate ?? 0.0)
            totalCostValue.text = Validation.currency(from: try gstModel?.calculateTtlCost() ?? 0.0)
            balanceValue.text = Validation.currency(from: try gstModel?.calculateBalance() ?? 0.0)
            _ = try gstModel?.checkOut()
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
        
        gstModel?.actionModel.action = Action.Edit
        gstModel?.actionModel.row = indexPath.row
        // call the segue - AddItemSegueID
        performSegue(withIdentifier: "AddItemSegueID", sender: nil)
        
    }
    
}

// When the user scrolls off the screen the cell gets dequeued to conserve memor
extension GroceryStoreTripListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gstModel?.myCart.count ?? 0
    }


    // Custom Table
    // Handles displaying the information per cell for eaach row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = groceryStoreTripTableView.dequeueReusableCell(withIdentifier: "gstCellID", for: indexPath) as! GSTTableViewCell

        // var groceryItem: GroceryItem?

        do {
            let groceryItem = try gstModel?.getGroceryCartItem(index: indexPath.row)
            // item quantity
             var ttlCost = 0.0
            if groceryItem!.cost != nil && groceryItem!.quantity != 0 {
                ttlCost = (groceryItem!.cost ?? 0.0) * Double(groceryItem!.quantity)
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
        view.layoutIfNeeded()
    }
}


extension  GroceryStoreTripListViewController : UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        // If code does not execute -- did I hook up the delegate???
        do {
            // Focus may have just left one object, however both need to be valid to enable the save
            if (textField == budgetValue ) {
                guard let budget = try? Validation.validateDouble(doubleValue: textField.text) else {
                    throw(GroceryStoreTripError.nonIntegerValue)
                }
                guard let taxRate = try? Validation.validateDouble(doubleValue: taxRateValue.text) else {
                    throw(GroceryStoreTripError.nonIntegerValue)
                }
                
                // if budget was valid and model generated
                if (generateModel(budget: budget, taxRate: taxRate)) {
                    addButton.isEnabled = true
         //           budgetValue.text = Validation.currency(from: budget)
                    budgetValue.text = String(budget)
                    gstModel?.update(budget: budget)
                    // Since we updated the data, let's recalculate totals
                    calculateTotals()
                } else {
                    // reset the old value
        //            budgetValue.text = Validation.currency(from: gstModel?.budget ?? 0.0)
                    budgetValue.text = String(gstModel?.budget ?? 0.0)
                    addButton.isEnabled = false
                }
            }
            if (textField == taxRateValue ) {
                guard let taxRate = try? Validation.validateDouble(doubleValue: textField.text) else {
                    throw(GroceryStoreTripError.nonIntegerValue)
                }
                if taxRate > 0.0 {
                    _ = try gstModel?.updateTaxRate(taxRate: taxRate)
                    addButton.isEnabled = true
                    // Since we updated the data, let's recalculate totals
                    calculateTotals()
                } else {
                    // reset the old value
                    taxRateValue.text = String(gstModel?.taxRate ?? 0.0)
                    addButton.isEnabled = false
                }
            }
        } catch {
            addButton.isEnabled = false
        }
        
        
        
        // return false means focus is retained on field
        return true
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        
        self.view.addGestureRecognizer(gesture)
        dismissKeyboardGesture = gesture
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let gesture = dismissKeyboardGesture {
            self.view.removeGestureRecognizer(gesture)
            dismissKeyboardGesture = nil
        }
        textField.resignFirstResponder()
        return true
    }
}
