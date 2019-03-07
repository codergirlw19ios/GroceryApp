//
//  File.swift
//  GroceryApp
//
//  Created by Messaging on 3/6/19.
//

import Foundation

class GroceryTrip {
    private var userBudget: Double = 0.0
    private var shoppingListDictionary:[GroceryItem:Bool]
    private var cart:[GroceryItem] = []
    private var taxRate: Double = 0.0
    
    var totalCost: Double {
        let total = cart.reduce(0) {(result, next) -> Double in
            return result + (next.cost! * Double(next.quantity))
        }
        
        return total * (1.0 + taxRate)
    }
    
    var balance:Double {return userBudget - totalCost}
    
    init(userBudget: Double,shoppingListArray:[GroceryItem],taxRate: Double) {
        
        self.userBudget = userBudget
        self.taxRate = taxRate
        
        let tempShoppingList = Set<GroceryItem>(shoppingListArray)
        shoppingListDictionary = Dictionary(uniqueKeysWithValues: tempShoppingList.map {(item: $0 , inCart: false) })
        
    }
    
    
    
    
    
    
    //if (balance < 0) {throw GroceryTripError.totalExceedBudget}
    
    
    
    
}
