//
//  ShoppingListPersistence.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/17/19.
//

import Foundation

class ShoppingListPersistence: Persistence {

    // read JSON from file
    func shoppingList() -> [ShoppingListItem] {
        return super.read()
    }

    // write JSON to file
    func write(_ list: [ShoppingListItem]) {
        super.write(list)
    }
}
