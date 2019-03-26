//
//  ViewController.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 2/26/19.
//

import UIKit

class ShopperViewController: UIViewController {

    // have a PTR to the ShopperModel
    var model:  Shopper?
    
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
    
    @IBAction func userTappedCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // The event of Save Tapped happens before the textFieldShouldEndEditing event  -- weird??
    @IBAction func userTappedSave(_ sender: UIButton) {
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
        
        
        // dismiss this modal dialog --
        dismiss(animated: true, completion: nil)
    }

}


extension  ShopperViewController : UITextFieldDelegate {
    
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
    
    //Laurie:  Amanda rewrite --This function is called with every keystroke change -- string contains 1 char -- user other method
//    func textField( _ textField: UITextField,
//        shouldChangeCharactersIn range: NSRange,
//        replacementString string: String
//        ) -> Bool {
//
////        guard let model = model else {
////            saveButton.isEnabled = false
////            return true
////        }
//
//        // TODO: handle specific error cases and inform user of
//        // why the save button is disabled
//
//        do {
//            if textField == qtyTextField {
//                _ = try model.validateInt(qty: string)
//                try model.validateString(name: nameTextField.text)
//            } else if textField == nameTextField {
//                try model.validateString(name: string)
//                _ = try model.validateInt(qty: qtyTextField.text)
//            }
//            saveButton.isEnabled = true
//        } catch {
//            saveButton.isEnabled = false
//        }
//
//        return true
//    }
}
    

