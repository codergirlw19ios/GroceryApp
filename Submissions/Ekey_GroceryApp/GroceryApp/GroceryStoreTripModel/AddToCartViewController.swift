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
    
    @IBOutlet weak var saveButton: UIButton!
    
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
    }
    
    @IBAction func userTappedCancel(_ sender: UIButton) {
        // call dismiss - so no memory leak with gstModel
        // if we don't call dismiss, the gstModel has a reference count which never goes down
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userTappedSave(_ sender: UIButton) {
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
        
        let groceryItem = GroceryItem(itemName, itemQty, itemCost )
        
        do {
            try gstModel?.addGroceryItemToCart( groceryItem, true )
            itemNameTextField.text!.removeAll()
            qtyTextField.text!.removeAll()
            costTextField.text!.removeAll()
            
            // somehow we need to notify the GroceryStoreTripViewContoller that we added and Item and to show it in the list..
            // I think they add a notification to the addGroceryItemToCart -- then anyone who is listening can do what they need to do
            
        } catch {
            print(error)
            return
        }
        // dismiss this modal dialog --  so memory is properly cleaned up
        dismiss(animated: true, completion: nil)
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
                try gstModel?.validateString(stringValue: textField.text)
                _ = try gstModel?.validateInt(intValue: qtyTextField.text)
                _ = try gstModel?.validateDouble(doubleValue: costTextField.text)
            }
            if (textField == qtyTextField) {
                let _ = try gstModel?.validateInt(intValue: textField.text)
                try gstModel?.validateString(stringValue: itemNameTextField.text)
                _ = try gstModel?.validateDouble(doubleValue: costTextField.text)
            }
            if (textField == costTextField) {
                let _ = try gstModel?.validateDouble(doubleValue: textField.text)
                try gstModel?.validateString(stringValue: itemNameTextField.text)
                _ = try gstModel?.validateInt(intValue: qtyTextField.text)
            }
            saveButton.isEnabled = true
        } catch {
            saveButton.isEnabled = false
        }
        
        
        // return false means focus is retained on field
        return true
    }
}
