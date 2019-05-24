//
//  RecipeTableViewCell.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 5/21/19.
//

import Foundation
import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func decorate(recipe: Recipe?) {
        guard let recipe = recipe else {
            return
        }
        textLabel?.text = recipe.name
        
            let ingredients = (recipe.ingredients).map{ (groceryItem) -> String in
                groceryItem.name}
                
            detailTextLabel?.text = ingredients.joined(separator: ",")
        }
    }

