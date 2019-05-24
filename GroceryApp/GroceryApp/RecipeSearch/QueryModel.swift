//
//  QueryModel.swift
//  GroceryApp
//
//  Created by johnekey on 5/16/19.
//

import Foundation
import UIKit


class QueryModel {

    var ingredients: [String]
    var row: Int?
    var ingredientCount: Int { return ingredients.count }
    
    init(ingredients: [String])
    {
        self.ingredients = ingredients
    }
    
    func getIngredient(row: Int) -> String {
        return ingredients[row]
    }

    func updateIngredient(row: Int, name: String) {
        ingredients[row] = name
    }
    
}

