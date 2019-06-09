//
//  QueryModel.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/30/19.
//

import Foundation

class QueryModel {
    var ingredients: [String]

    init() {
        ingredients = []
    }

    var selectedRow: Int? = nil

    var ingredientCount: Int { return ingredients.count }

    func ingredientFor(row: Int) -> String? {
        guard row < ingredientCount else { return nil }
        return ingredients[row]
    }

    func addIngredient() {
        ingredients.insert("", at: 0)
    }

    func updateSelectedRow(_ ingredient: String) {
        guard let selectedRow = selectedRow else {
            return
        }

        ingredients[selectedRow] = ingredient
        self.selectedRow = nil
    }
}
