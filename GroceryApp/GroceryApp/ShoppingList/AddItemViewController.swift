//
//  ViewController.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 2/26/19.
//

import UIKit

class AddItemViewController: UIViewController {
    
    var model : ShoppingListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isUserInteractionEnabled = false
        quantityTextField.delegate = self
        nameTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var quantityTextField: UITextField!
    @IBAction func userTappedSave(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        quantityTextField.resignFirstResponder()
        guard let name = nameTextField.text, let quantity = Int(quantityTextField.text ?? "") else {
            return
        }
        
        let groceryItem = model?.addItemToShoppingList(name: name, quantity: quantity)
        guard groceryItem != nil else {return}
        
        dismiss(animated: true, completion: nil)
    }
}
extension AddItemViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //name String not blank, quantity Int else don't save
        let name = try? model?.validate(name: nameTextField.text)
        let quantity = try? model?.validate(quantity: quantityTextField.text)
        if name != nil, quantity != nil {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
//            catch is StringValidationError {
//            saveButton.isEnabled = false
//        } catch {
//            print("unknown error \(error)")
//        }
        return true
    }
}

