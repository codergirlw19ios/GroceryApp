//
//  QueryTableViewCell.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 5/24/19.
//

import UIKit

class QueryTableViewCell: UITableViewCell, UITextFieldDelegate {
 
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
    }

}
