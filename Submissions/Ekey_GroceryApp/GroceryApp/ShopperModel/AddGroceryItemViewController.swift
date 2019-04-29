//
//  ViewController.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 2/26/19.
//

import UIKit

class AddGroceryItemViewController: UIViewController {

    // have a PTR to the ShopperModel
    var model:  Shopper?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        // self = AddGroceryItemViewController -- i.e. Look for the delegate handler in AddGroceryItemViewController
        qtyTextField.delegate = self
        nameTextField.delegate = self
    }
    
    @IBAction func userTappedCancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)

    }
    // The event of Save Tapped happens before the textFieldShouldEndEditing event  -- weird??
    @IBAction func userTappedSave(_ sender: UIBarButtonItem) {
        // Tell the nameTextField to loose focus and execute delegate
        nameTextField.resignFirstResponder()
        qtyTextField.resignFirstResponder()
        
        // How to see value of variable in closure?? use command line po variablename
        
        // If the name and Qty text files are not empty, then create grocery item and add
        guard let itemName = nameTextField.text, let itemQty = Int(qtyTextField.text ?? "") else {
            saveButton.isEnabled = false
            return
        }
        
        let groceryItem = GroceryItem(itemName, itemQty )
        
        do {
            try model?.addGroceryItemToList( groceryItem )
            nameTextField.text!.removeAll()
            qtyTextField.text!.removeAll()
            
            // somehow we need to notify the GroceryListViewContoller that we added and Item and to show it in the list..
            // I think they add a notification to the addGroceryItemToList -- then anyone who is listening can do what they need to do
            
        } catch {
            print(error)
            return
        }
        
        navigationController?.popViewController(animated: true)

    }

}


extension  AddGroceryItemViewController : UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
    // If code does not execute -- did I hook up the delegate???
    do {
        // Focus may have just left one object, however both need to be valid to enable the save
        if (textField == nameTextField) {
            try model?.validateString(name: textField.text)
            _ = try model?.validateInt(qty: qtyTextField.text)
        }
        if (textField == qtyTextField) {
            let _ = try model?.validateInt(qty: textField.text)
            try model?.validateString(name: nameTextField.text)
        }
        saveButton.isEnabled = true
    } catch {
        saveButton.isEnabled = false
    }
    
    
    // return false means focus is retained on field
    return true
    }
    
}
    

