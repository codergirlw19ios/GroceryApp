//
//  QueryTableViewCell.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 5/24/19.
//

import UIKit

protocol QueryTableViewCellDelegate: class {
    func textFieldDidEndEditing(_ textField: UITextField)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
}

class QueryTableViewCell: UITableViewCell, UITextFieldDelegate {
 
    weak var delegate: QueryTableViewCellDelegate?
    
    @IBOutlet weak var ingredientTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func decorate(ingredient: String?) {
        ingredientTextField.text = ingredient
        ingredientTextField.delegate = self
    }
    
    // uitextfield delegate methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(textField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldBeginEditing(textField) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(textField) ?? true
    }

}
