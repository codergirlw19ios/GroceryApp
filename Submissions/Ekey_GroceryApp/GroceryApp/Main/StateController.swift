//
//  StateController.swift
//  GroceryApp
//
//  Created by johnekey on 4/24/19.
//

import Foundation

class StateController {
    
    // create a singleton for StateController
    static let shared = StateController(persistence: GroceryListPersistence())
    
    private let persistence: GroceryListPersistence
    
    public  var myGroceryList: [GroceryItem] {
        didSet {
           persistence.writeGroceryList(myGroceryList)
        }
    }
   // var shoppingList: [GroceryItem] = []
    
    private init( persistence: GroceryListPersistence) {
        self.persistence = persistence
        // read the data from the file and initialize list
        myGroceryList = persistence.readGroceryList()
    }
}
