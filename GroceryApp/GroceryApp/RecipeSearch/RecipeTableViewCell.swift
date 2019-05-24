//
//  RecipeTableViewCell.swift
//  GroceryApp
//
//  Created by johnekey on 5/16/19.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func decorateCell(with recipeItem: Recipe?){
        guard let recipeItem = recipeItem else {
            return
        }
        textLabel?.text = recipeItem.name
        // an array of strings
        let ingredients = recipeItem.ingredients.map { (groceryItem) -> String in groceryItem.name }
        // join the strings together into 1 string separated by a comma
        detailTextLabel?.text = ingredients.joined(separator: ",")
     }
}
