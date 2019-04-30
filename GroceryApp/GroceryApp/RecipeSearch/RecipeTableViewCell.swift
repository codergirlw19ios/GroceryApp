//
//  RecipeTableViewCell.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/29/19.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    func decorateCell(with recipe: Recipe?){
        self.textLabel?.text = recipe?.name
        self.detailTextLabel?.text = recipe?.ingredients.map { $0.name }.joined(separator: ",")
    }
}
