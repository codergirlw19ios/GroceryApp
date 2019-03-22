//
//  ViewController.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 2/26/19.
//

import UIKit

class ShopperViewController: UIViewController {

    let model = Shopper()
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var qtyTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        // self = ShopperViewController -- i.e. Look for the delegate handler in ShopperViewController
        qtyTextField.delegate = self
        nameTextField.delegate = self
    }
    
    // The event of Save Tapped happens before the textFieldShouldEndEditing event  -- weird??
    @IBAction func userTappedSave(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        qtyTextField.resignFirstResponder()
        
        // How to see value of variable in closure?? use command line po variablename
        
        // If the name and Qty text files are not empty, then create grocery item and add
        guard let itemName = nameTextField.text, let itemQty = Int(qtyTextField.text ?? "") else {
            saveButton.isEnabled = false
            return
        }
        
        let groceryItem = GroceryItem(itemName, itemQty, 2.50 )
        
        do {
            try model.addGroceryItemToList( groceryItem )
            nameTextField.text!.removeAll()
            qtyTextField.text!.removeAll()
            
        } catch {
            print(error)
            return
        }
        
        print(groceryItem)
    }

}


extension  ShopperViewController : UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    
    // If code does not execute -- did I hook up the delegate???
    do {
        // Focus may have just left one object, however both need to be valid to enable the save
        if (textField == nameTextField) {
            try model.validateString(name: textField.text)
            _ = try model.validateInt(qty: qtyTextField.text)
        }
        if (textField == qtyTextField) {
            let _ = try model.validateInt(qty: textField.text)
            try model.validateString(name: nameTextField.text)
        }
        saveButton.isEnabled = true
    } catch {
        saveButton.isEnabled = false
    }
    
    
    // return false means focus is retained on field
    return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        let xxx = 5
        
5    }
}
    

