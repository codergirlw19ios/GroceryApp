//
//  RecipeSearchPersistence.swift
//  GroceryApp
//
//  Created by johnekey on 5/16/19.
//

import Foundation

class RecipeSearchPersistence: Persistence {
    
    // read JSON from file
    func readRecipeSearchQuery() -> RecipeSearchQuery? {
        return super.read()
    }
 
    // write JSON to file
    func writeRecipeSearchQuery(_ item: RecipeSearchQuery) {
        super.write(item)
    }
}
