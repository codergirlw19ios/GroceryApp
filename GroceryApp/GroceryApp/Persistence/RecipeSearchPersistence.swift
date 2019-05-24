//
//  RecipeSearchPersistence.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 5/17/19.
//

import Foundation

class RecipeSearchPersistence: Persistence {
    func readRecipeSearchQuery() -> RecipeSearchQuery? {
        return super.read()
    }
    
    func writeRecipeSearchQuery(_ item: RecipeSearchQuery) {
        super.write(item)
    }
}
