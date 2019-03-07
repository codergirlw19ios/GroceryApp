//
//  GroceryTrip.swift
//  WeekFiveProject
//
//  Created by Melissa Bain on 2/24/19.
//  Copyright © 2019 MB Consulting. All rights reserved.
//

import Foundation

class GroceryTrip {
    private var budget: Double
    private var shoppingList = [GroceryItem: Bool]()
    private var cart = [GroceryItem]()
    private var taxRate: Double = 0.0
    
    var totalCost: Double {
        let accumulatingTotal = cart.reduce(0) {(result, next) -> Double in
            return result + (next.cost! * Double(next.quantity))
        }
        
        return accumulatingTotal * (1.0 + taxRate)
    }
    
    var balance: Double {
        return budget - totalCost
    }
    
    init(budget: Double, arrShoppingList: [GroceryItem] , taxRate: Double) {
        self.budget = budget
        self.taxRate = taxRate
        
        let uniqueShoppingList = Set<GroceryItem>(arrShoppingList)
        shoppingList = Dictionary(uniqueKeysWithValues: uniqueShoppingList.map { (item: $0 , inCart: false) })
    }
    
    func addToCart(name: String, unit: Int, price: Double) throws {
        guard shoppingList.contains(where: { $0.key.itemName == name }) else {
            throw GroceryTripError.noItem
        }
        
        guard shoppingList.contains(where: { $0.key.itemName == name && $0.key.quantity >= unit }) else {
            throw GroceryTripError.exceedsAmount
        }
        
        guard shoppingList.contains(where: { $0.key.itemName == name && $0.key.quantity <= unit }) else {
            throw GroceryTripError.belowAmount
        }
        
        if shoppingList.contains(where: { $0.key.itemName == name && $0.key.quantity == unit }) {
            var groceryItem: GroceryItem
            groceryItem = GroceryItem(itemName: name, quantity: unit, cost: price)
            
            cart.append(groceryItem)
            
            shoppingList[groceryItem] = true
            
            guard balance <= budget else {
                throw GroceryTripError.exceedsBudget
            }
        }
    }
    
    func removeFromCart(item: GroceryItem) {
        if let index = cart.index(of: item) {
            cart.remove(at: index)
        }
        
        if shoppingList.contains(where: { $0.key == item }) {
            shoppingList[item] = false
        }
    }
    
    func checkout() throws -> ([GroceryItem], Double) {
        guard taxRate > 0.0 else {
            throw GroceryTripError.noTax
        }
        
        guard balance >= 0.0 else {
            throw GroceryTripError.exceedsBudget
        }
        
        var remainingItems = [GroceryItem]()
        
        for (item, inCart) in shoppingList {
            if inCart == true {
                shoppingList.removeValue(forKey: item)
                
                remainingItems.append(item)
            }
        }
        
        let availableBalance = balance
        
        return (remainingItems, availableBalance)
    }
    
    func updateTaxRate(taxRate: Double) throws {
        self.taxRate = taxRate
        
        guard totalCost <= budget else {
            throw GroceryTripError.exceedsBudget
        }
    }
}
