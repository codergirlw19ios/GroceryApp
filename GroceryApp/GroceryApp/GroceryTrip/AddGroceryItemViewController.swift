//
//  AddGroceryItemViewController.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 4/1/19.
//

import UIKit
class AddGroceryItemViewController: UIViewController {
    
    var model : GroceryTrip?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var quantityTextField: UITextField!
    
    
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        quantityTextField.delegate = self
        nameTextField.delegate = self
        costTextField.delegate = self
    }
    
    @IBAction func userTappedSave(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        quantityTextField.resignFirstResponder()
        costTextField.resignFirstResponder()
        guard let name = nameTextField.text,
            let quantity = Int(quantityTextField.text ?? ""),
            let cost = Double(costTextField.text ?? "") else {
            return
        }
        
        do {
            let groceryItem = try model?.addGroceryItemToCart(cost: cost, quantity: quantity, name: name)
        
        guard groceryItem != nil else {
            return
        }
        }
        catch {
            print(error)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userTappedCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddGroceryItemViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
        ) -> Bool {
        
        guard let model = model else {
            saveButton.isEnabled = false
            return true
        }
        
        // TODO: handle specific error cases and inform user of
        // why the save button is disabled
        var name: String?
        var quantity: Int?
        var cost: Double?
        if textField == quantityTextField {
            quantity = try? model.validate(quantity: string)
            name = try? model.validate(name: nameTextField.text)
            cost = try? model.validate(cost:costTextField.text)
        } else if textField == nameTextField {
            name = try? model.validate(name: string)
            quantity = try? model.validate(quantity: quantityTextField.text)
            cost = try? model.validate(cost:costTextField.text)
        } else if textField == costTextField {
            cost = try? model.validate(cost: string)
            name = try? model.validate(name: nameTextField.text)
            quantity = try? model.validate(quantity: quantityTextField.text)
            
        }
        
        if name != nil, quantity != nil {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        
        return true
    }
}
