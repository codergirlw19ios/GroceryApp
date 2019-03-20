//
//  GroceryTrip.swift
//  GroceryApp
//
//  Created by Sandra Laguerta on 3/18/19.
//

import Foundation

class GroceryTrip {
    private var budget: Double
    private var shoppingList: [GroceryItem : Bool]
    private var cart: [GroceryItem] = []
    //A PERCENTAGE
    private var taxRate: Double
    
    init(budget: Double, shoppingListArray: [GroceryItem], taxRate: Double) {
        self.budget = budget
        let shoppingListSet = Set(shoppingListArray)
        let shoppingListMap = shoppingListSet.map({(groceryItem: GroceryItem) -> (groceryItem: GroceryItem, inCart: Bool) in return (groceryItem, false)})
        
        shoppingList = Dictionary(uniqueKeysWithValues: shoppingListMap)
        
        self.taxRate = taxRate
    }
    
    
    var totalCost: Double {
        let accumulatingTotal = cart.reduce(0) { (result, nextValue) -> Double in
            return result + (nextValue.cost! * Double(nextValue.quantity))
        }
        //taxRate is a percentage so divide it by 100 and add 1 so totalCost = accumulatingTotal PLUS tax
        return accumulatingTotal * (1 + (taxRate / 100))
    }
    
    var balance: Double {
        return budget - totalCost
    }
    
    //In your function to add to cart: Allow for the user to override shopping list errorts and add the item as they entered it anyway; still throw the final error for exceeding budget if necessary.
    
    //func addToCart(cost: Double, quantity: Int, item: GroceryItem) throws {
    func addToCart(groceryItem: GroceryItem) throws{
        //If the string does not match any of the GroceryItems' names in the shopping list dictionary, throw the appropriate error.
        guard shoppingList.contains(where: {$0.key.name == groceryItem.name}) else {
            throw GroceryTripError.unplannedGroceryItem
        }
        
        //If the quantity does not match the GroceryItem's quantity in the shopping list dictionary, throw the appropriate error.
        guard shoppingList.contains(where: { $0.key.name == groceryItem.name && $0.key.quantity == groceryItem.quantity } ) else {
            if shoppingList.contains(where: { $0.key.name == groceryItem.name && $0.key.quantity < groceryItem.quantity} ) {
                throw GroceryTripError.shortQuantity }
            else {
                throw GroceryTripError.excessQuantity
            }
        }
        
        //If the quantity matches, update the dictionary's boolean to true and add the GroceryItem with cost to the cart array. Check the new balance and throw an error if necessary.
        
        if shoppingList.contains(where: {$0.key.name == groceryItem.name && $0.key.quantity == groceryItem.quantity}) || shoppingList.contains(where: {$0.key.name == groceryItem.name && $0.key.quantity != groceryItem.quantity}) {
            let item: GroceryItem = groceryItem
            shoppingList[item] = true
            cart.append(item)
            
            guard balance <= budget else {
                throw GroceryTripError.totalExceedsBudget
            }
        }
        
    }
    
    //Write another function to remove an item from the cart. Take in the parameter of GroceryItem. Remove it from the array, and find the matching item in the shopping list (if it exists) and update the dictionary's boolean to false.
    
    func removeFromCart (groceryItem: GroceryItem){
        if let itemIndex = cart.index(of: groceryItem){
            cart.remove(at: itemIndex)
        }
        
        if shoppingList.contains(where: { $0.key.name == groceryItem.name }) {
            shoppingList[groceryItem] = false
        }
        
    }
    
    //Write a function to checkout that can throw an error. This function will return the remaining items on the shopping list and the remaining budget in a tuple. If the tax rate is 0.0, return the appropriate error. If the balance is negative, throw the appropriate error. Otherwise, remove everything from the shopping list whose boolean evaluates to true and return everything on the shopping list that wasn't purchased, and return the remaining available budget amount. Do not return a dictionary, but return an array of GroceryItem.
    func checkout() throws -> (remainingBudget: Double, nonPurchasedItems: [GroceryItem])  {
        if taxRate == 0.0 {
            throw GroceryTripError.noTax
        }
        
        if balance < 0.0 {
            throw GroceryTripError.totalExceedsBudget
        }
        
        var nonPurchasedItems = [GroceryItem]()
        
        for (item, inCart) in shoppingList {
            if inCart == true {
                self.shoppingList.removeValue(forKey: item)
            } else {
                nonPurchasedItems.append(item)
            }
        }
        
        return ( budget, nonPurchasedItems )
    }
    
    //Write another function to update the tax rate that can throw an error. Take in the appropriate parameter. Be sure to update the total. Throw an error if the new total exceeds the budget.
    func updateTaxRate(taxRate: Double) throws {
        self.taxRate = taxRate
        
        let newTotal = totalCost
        guard newTotal <= budget else {
            throw GroceryTripError.totalExceedsBudget
        }
    }
}
