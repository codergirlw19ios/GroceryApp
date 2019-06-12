//
//  QueryModel.swift
//  GroceryApp
//
//  Created by johnekey on 5/16/19.
//

import Foundation
import UIKit

protocol QueryDelegate: class {
    func dataUpdated()
}

class QueryModel {

    weak var delegate: QueryDelegate?
    var ingredients: [String]
    var row: Int?
    var ingredientCount: Int { return ingredients.count }
    
    init(ingredients: [String])
    {
        self.ingredients = ingredients
        self.row = -1
        self.row = nil
    }
    
    func getIngredient(row: Int) -> String {
        return ingredients[row]
    }

    
    func updateIngredient(name: String) {
        if row != nil {
            ingredients[row!] = name
        }
        //       delegate?.dataUpdated()
    }
    
    func addIngredient(name: String) {
        ingredients.insert(name, at: 0)
 //       delegate?.dataUpdated()
    }
}

