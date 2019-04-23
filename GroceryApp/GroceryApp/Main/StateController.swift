//
//  StateController.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/15/19.
//

import Foundation

class StateController {

    static let shared = StateController(persistence: GroceryItemPersistence(filename: "ShoppingList"))

    private let persistence: GroceryItemPersistence
    
    var shoppingList: [GroceryItem] {
        didSet {
            persistence.write(shoppingList)
        }
    }

    private init(persistence: GroceryItemPersistence) {
        self.persistence = persistence
        shoppingList = persistence.groceryItems()
    }
}

