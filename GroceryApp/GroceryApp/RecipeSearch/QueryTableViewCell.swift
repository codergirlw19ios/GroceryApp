//
//  QueryTableViewCell.swift
//  GroceryApp
//
//  Created by johnekey on 5/17/19.
//

import UIKit

protocol QueryTableViewCellDelegate: class {
    
   func textFieldDidEndEditing(_ textField: UITextField)
   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
   func textFieldShouldReturn(_ textField: UITextField) -> Bool
}

class QueryTableViewCell: UITableViewCell, QueryTableViewCellDelegate {
    
    @IBOutlet weak var ingredientField: UITextField!
    weak var qtvcDelegate: QueryTableViewCellDelegate?

    func decorateCell(with ingredient: String?){

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
    func textFieldDidEndEditing(_ textField: UITextField) {
        qtvcDelegate?.textFieldDidEndEditing(textField)
    }
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return qtvcDelegate?.textFieldShouldBeginEditing(textField) ?? true

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return qtvcDelegate?.textFieldShouldReturn(textField) ?? true

    }
}
