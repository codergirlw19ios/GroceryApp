//
//  QueryTableViewCell.swift
//  GroceryApp
//
//  Created by johnekey on 5/17/19.
//

import UIKit

protocol QueryTableViewCellDelegate: class {
    
   func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason)
   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
   func textFieldShouldReturn(_ textField: UITextField) -> Bool
}

class QueryTableViewCell: UITableViewCell, QueryTableViewCellDelegate {
    
    @IBOutlet weak var ingredientField: UITextField!
    weak var qtvcDelegate: QueryTableViewCellDelegate?

    func decorateCell(with ingredient: String?){
        guard let ingredient = ingredient else {
            return
        }
        ingredientField.text = ingredient
        ingredientField.delegate = self
 
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension QueryTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == ingredientField {
     //       let ingredient = try? Validation.notEmpty(textField.text)
            qtvcDelegate?.textFieldDidEndEditing(textField, reason: reason)
        }
    }
    
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
