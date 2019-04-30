//
//  RecipeSearch.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/29/19.
//

import Foundation
import UIKit

class RecipeSearchPersistence: Persistence {

    // read JSON from file
    func searchQuery() -> RecipeSearchQuery? {
        return super.read()
    }

    // write JSON to file
    func write(_ query: RecipeSearchQuery) {
        super.write(query)
    }
}
