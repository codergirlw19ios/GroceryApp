import UIKit

class AddItemViewController: UIViewController {
    var model: ShoppingListModel?

    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        print(#function + "Add Item")
        super.viewDidLoad()

        saveButton.isEnabled = false

        quantityTextField.delegate = self
        nameTextField.delegate = self

        nameTextField.becomeFirstResponder()
    }

    @IBAction func cancelButtonTapped(_sender : Any?) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        nameTextField.resignFirstResponder()
        quantityTextField.resignFirstResponder()
        
        guard let name = nameTextField.text, let quantity = Int(quantityTextField.text ?? "") else {
            return
        }

        let groceryItem = model?.addItemToShoppingList(name: name, quantity: quantity)

        guard groceryItem != nil else {
            return
        }

        cancelButtonTapped(_sender: nil)
    }

    deinit {
        print("deinit AddItemViewController")
    }
}

extension AddItemViewController: UITextFieldDelegate {
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
        if textField == quantityTextField {
            quantity = try? model.validate(quantity: string)
            name = try? model.validate(name: nameTextField.text)
        } else if textField == nameTextField {
            name = try? model.validate(name: string)
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
