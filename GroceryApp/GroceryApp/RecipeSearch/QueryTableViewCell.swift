//
//  QueryTableViewCell.swift
//  GroceryApp
//
//  Created by johnekey on 5/17/19.
//

import UIKit

class QueryTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientField: UITextField!
    

    func decorateCell(with ingredient: String?){
        guard let ingredient = ingredient else {
            return
        }
        ingredientField.text = ingredient
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
