//
//  AddToCartViewController.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 3/27/19.
//

import UIKit

class AddToCartViewController: UIViewController {
    var model: GroceryTripModel?

    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false

        quantityTextField.delegate = self
        nameTextField.delegate = self
        costTextField.delegate = self
    }

    @IBAction func cancelButtonTapped(_sender : Any?) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let model = model, let name = nameTextField.text, let quantity = Int(quantityTextField.text ?? ""), let cost = Double(costTextField.text ?? "") else {
            print("invalid")
            return
        }

//        do {
            try? model.addToCart(name: name, quantity: quantity, cost: cost)
//        } catch let error as GroceryTripError { // TODO: handle errors individually and inform user what faileds
//            print(error)
//            return
//        } catch {
//            print(#function)
//            return
//        }

        cancelButtonTapped(_sender: nil)
    }

    deinit {
        print("deinit AddToCartViewController")
    }
}

extension AddToCartViewController: UITextFieldDelegate {
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
            cost = try? model.validate(cost: costTextField.text)
        } else if textField == nameTextField {
            name = try? model.validate(name: string)
            quantity = try? model.validate(quantity: quantityTextField.text)
            cost = try? model.validate(cost: costTextField.text)
        } else if textField == costTextField {
            cost = try? model.validate(cost: string)
            name = try? model.validate(name: nameTextField.text)
            quantity = try? model.validate(quantity: quantityTextField.text)
        }

        if name != nil, quantity != nil, cost != nil {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
