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
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var feedbackView: FeedbackView!
    @IBOutlet weak var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false
        continueButton.isHidden = true
        feedbackView.layer.opacity = 0.0

        quantityTextField.delegate = self
        nameTextField.delegate = self
        costTextField.delegate = self

        nameTextField.becomeFirstResponder()
    }

    @IBAction func cancelButtonTapped(_sender : Any?) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveButtonTapped(_ sender: Any?) {
        guard let model = model, let name = nameTextField.text, let quantity = Int(quantityTextField.text ?? ""), let cost = Double(costTextField.text ?? "") else {
            print("invalid")
            return
        }

        do {
            try model.addToCart(name: name, quantity: quantity, cost: cost, overrideShoppingList: feedbackView.layer.opacity == 1.0)
        } catch let error as GroceryTripError {
            saveButton.isEnabled = false
            continueButton.isHidden = false
            feedbackView.update(message: error.description)
            feedbackView.toggleView(isHidden: false)
            return
        } catch {
            print(#function)
            return
        }

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

        validate(textField, replacementString: string)

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        validate(textField, replacementString: textField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension AddToCartViewController {
    func validate(_ textField: UITextField, replacementString string: String?) {
        continueButton.isHidden = true
        if feedbackView.layer.opacity == 1.0 {
            feedbackView.toggleView(isHidden: true)
        }
        
        guard let model = model else {
            saveButton.isEnabled = false
            return
        }

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
    }
}
