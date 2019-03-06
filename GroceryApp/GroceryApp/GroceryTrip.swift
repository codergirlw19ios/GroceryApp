//
//  File.swift
//  GroceryApp
//
//  Created by Messaging on 3/6/19.
//

import Foundation

class GroceryTrip {
    private var userBudget: Double
    private var shoppingListDictionary:[GroceryItem:Bool]
    private var cart:[GroceryItem]
    private var taxRate: Double = 0.0
    var totalCost:Double
    
    init(userBudget: Double,shoppingListArray:[GroceryItem],taxRate: Double) {
        
        self.userBudget = userBudget
        self.taxRate = taxRate
    
    }
    
    
    
    
    
}
