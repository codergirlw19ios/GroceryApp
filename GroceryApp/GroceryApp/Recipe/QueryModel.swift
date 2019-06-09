//
//  QueryModel.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 5/22/19.
//

import Foundation
import UIKit

class QueryModel {
    
    var ingredients: [String]
    var row: Int?

    init(ingredients: [String]) {
        self.ingredients = ingredients
    }
    
    func getNumberOfIngredients() -> Int {
        return ingredients.count
    }
    
    func getIngredient(row: Int) -> String {
        return ingredients[row]
    }
    
    func updateIngredient(ingredient: String) {
        guard let row = row else {
            return
        }
        
        ingredients[row] = ingredient
    }
    
    func addIngredient() {
        ingredients.append("")
    }
    
    
}
