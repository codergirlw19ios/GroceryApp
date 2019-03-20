import UIKit

class AddItemViewController: UIViewController {
    var model: ShoppingListModel?

    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false

        quantityTextField.delegate = self
        nameTextField.delegate = self
    }

    @IBAction func userTappedButton(_ sender: UIButton) {
        guard let name = nameTextField.text, let quantity = Int(quantityTextField.text ?? "") else {
            return
        }

        let groceryItem = model?.addItemToShoppingList(name: name, quantity: quantity)
        print(groceryItem ?? "")
    }
}

extension AddItemViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, //textfield that's calling
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
        ) -> Bool {
        
        
        guard let model = model else {
            saveButton.isEnabled = false
            return true
        }
        
        var name: String?  //?? //two question marks
        var quantity: Int? //?? //optional wrapped in an optional or Optional<optional(Int)>
        
        if textField == quantityTextField {
            //validate with string
            //and validate name wiht nameTextField.text
            name = try? model.validate(name: string)
            quantity = try? model.validate(quantity: string)
           
        } else if textField === nameTextField {
            //validate name with strin
            name = try? model.validate(name: string)
            quantity = try? model.validate(quantity: string)
            //validate quanity with quanitytextfield.text
            
        }
        
        //validate on correct type with new value
    //the name text field  = self.nameTextField
    //quanityt text field is self.quantitytextfield

        
        //determine which text field just called this function
        //determine if current calling textfield is name or quanity; validate on correct type with new value


        if name != nil, quantity != nil {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }

        return true
    }
}
