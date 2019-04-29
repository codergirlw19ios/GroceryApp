//
//  StateController.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/15/19.
//

import Foundation

struct ShoppingListItem: Codable {
    var groceryItem: GroceryItem
    var inCart: Bool

    mutating func updateInCart() {
        inCart = !inCart
    }
}

class StateController {

    static let shared = StateController(persistence: ShoppingListPersistence(filename: "ShoppingList"))

    private let persistence: ShoppingListPersistence
    
    var shoppingList: [ShoppingListItem] {
        didSet {
            persistence.write(shoppingList)
        }
    }

    private init(persistence: ShoppingListPersistence) {
        self.persistence = persistence
        self.shoppingList = persistence.shoppingList()
    }
}

