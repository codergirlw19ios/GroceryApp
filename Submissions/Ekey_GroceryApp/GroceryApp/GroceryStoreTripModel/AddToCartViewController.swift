//
//  AddToCartViewController.swift
//  GroceryApp
//
//  Created by johnekey on 3/31/19.
//

import UIKit



class AddToCartViewController: UIViewController {

    // have a PTR to the GroceryStoreTrip
    var gstModel:  GroceryStoreTrip?
    var groceryItem: GroceryItem?
    var action = Action.Add
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false
        // self = AddToCartViewController -- i.e. Look for the delegate handler in AddToCartViewController
        qtyTextField.delegate = self
        itemNameTextField.delegate = self
        costTextField.delegate = self
        
        
        // if we have a model, get the action
        if (gstModel != nil) {
            action = gstModel!.actionModel.action
        }
        // if an Edit, the get the GroceryItem we are editing
        switch (action) {
            case(Action.Edit):
                do {
                    groceryItem = try gstModel?.getGroceryCartItem(index: (gstModel?.actionModel.row)!)
                    // populate fields on screen
                    if groceryItem != nil {
                        qtyTextField.text = String(groceryItem!.quantity)
                        itemNameTextField.text = groceryItem?.name
                        costTextField.text = (String(format:"%.1f", groceryItem!.cost ?? 0.0))
                        }
                } catch {
                    print(error)
            }
            default:
                return
        }
        
    }
    
    @IBAction func userTappedCancel(_ sender: UIBarButtonItem) {
        // call dismiss - so no memory leak with gstModel
        // if we don't call dismiss, the gstModel has a reference count which never goes down
        
        //Laurie:  Not sure we need this with a Navigation bar
        navigationController?.popViewController(animated: true)
       // dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userTappedSave(_ sender: UIBarButtonItem) {
        // Tell the nameTextField to loose focus and execute delegate
        itemNameTextField.resignFirstResponder()
        qtyTextField.resignFirstResponder()
        costTextField.resignFirstResponder()
        
        // How to see value of variable in closure?? use command line po variablename
        
        // If the name and Qty and cost text files are not empty, then create grocery item and add
        guard let itemName = itemNameTextField.text, let itemQty = Int(qtyTextField.text ?? ""), let itemCost = Double(costTextField.text ?? "") else {
            saveButton.isEnabled = false
            return
        }
        
        // if Edit, remove item from list and re-add
        if action == Action.Edit {
            if !(gstModel?.removeGroceryItemFromCart(groceryItem!))! {
                print("Grocery Item Not Found")
            }
            // clean up the action
            gstModel?.actionModel.action = Action.Add
            gstModel?.actionModel.row = 0
            
        }
        
        do {
            try gstModel?.addGroceryItemToCart( GroceryItem(itemName, itemQty, itemCost ), true )
            itemNameTextField.text!.removeAll()
            qtyTextField.text!.removeAll()
            costTextField.text!.removeAll()
            
            
            // somehow we need to notify the GroceryStoreTripViewContoller that we added and Item and to show it in the list..
            // I think they add a notification to the addGroceryItemToCart -- then anyone who is listening can do what they need to do
            
        } catch {
            print(error)
            return
        }
        navigationController?.popViewController(animated: true)
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

extension  AddToCartViewController : UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        // If code does not execute -- did I hook up the delegate???
        do {
            // Focus may have just left one object, however both need to be valid to enable the save
            if (textField == itemNameTextField) {
                try Validation.validateString(stringValue: textField.text)
                _ = try Validation.validateInt(intValue: qtyTextField.text)
                _ = try Validation.validateDouble(doubleValue: costTextField.text)
            }
            if (textField == qtyTextField) {
                let _ = try Validation.validateInt(intValue: textField.text)
                try Validation.validateString(stringValue: itemNameTextField.text)
                _ = try Validation.validateDouble(doubleValue: costTextField.text)
            }
            if (textField == costTextField) {
                let _ = try Validation.validateDouble(doubleValue: textField.text)
                try Validation.validateString(stringValue: itemNameTextField.text)
                _ = try Validation.validateInt(intValue: qtyTextField.text)
            }
            saveButton.isEnabled = true
        } catch {
            saveButton.isEnabled = false
        }
        
        
        // return false means focus is retained on field
        return true
    }
}
