//
//  ShoppingListPersistence.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 3/14/19.
//

import Foundation

class GroceryItemPersistence: Persistence {

    // read JSON from file
    func groceryItems() -> [GroceryItem] {
        return super.read()
    }

    // write JSON to file
    func write(_ list: [GroceryItem]) {
        super.write(list)
    }
}
