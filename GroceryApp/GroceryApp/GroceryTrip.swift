//
//  File.swift
//  GroceryApp
//
//  Created by Milan on 3/6/19.
//

import Foundation

class GroceryTrip {
    private var userBudget: Double = 0.0
    private var shoppingList:[GroceryItem:Bool]
    private var cart:[GroceryItem] = []
    private var taxRate: Double = 0.0
    
    var totalCost: Double {
        let accumulatedTotal = cart.reduce(0) {(x,y) in
            x + (y.cost! * Double(y.quantity))}
        return (accumulatedTotal * taxRate/100)
    }
    
    var balance:Double {return userBudget - totalCost}
    
    init(userBudget: Double,shoppingList:[GroceryItem],taxRate: Double) {
        self.userBudget = userBudget
        self.taxRate = taxRate
        
        // initializing set from array and then mapping over that set to form a tuple
        // let tempTuple = Set(shoppingList).map {($0,false)}
        
        //using Dictionary(uniqueKeyswithValues: sequence) to create dictionary from above tuple
        //self.shoppingList = Dictionary(uniqueKeysWithValues: tempTuple)
        
        //Another way for above 2 lines of code
        let tempTuple = Set(shoppingList)
        self.shoppingList = Dictionary(uniqueKeysWithValues: tempTuple.map{($0,false)})
    }
    
    // function to add item to the cart
    func addToCart (itemName:String, itemCost:Double, itemQuantity:Int) throws {
        
        // use guard instead of if when values must be present for a function
        // below code checks for item in shopping list array and if not found, throws error
        guard shoppingList.contains(where: {($0.key.name == itemName)})
            else {throw GroceryTripError.itemNotFound}
        
        // below code checks if quantity of an item exceed then it will exceed the amount
        guard shoppingList.contains(where: {($0.key.quantity > itemQuantity && $0.key.name == itemName)})
            else {throw GroceryTripError.qtyExceedAmt}
        
        // below code checks if quantity of an item is less then it be short of amount
        guard shoppingList.contains(where: {($0.key.quantity < itemQuantity && $0.key.name == itemName)})
            else {throw GroceryTripError.qtyShortOfReqAmt}
        
        // if quantity matches, update the dictionary's boolean to true and add the GroceryItem with cost to the cart //can't use guard since it asks for else stmt
        if shoppingList.contains(where: {($0.key.quantity == itemQuantity && $0.key.name == itemName)}) {
            cart.append(GroceryItem(name: itemName, quantity: itemQuantity, cost: itemCost))
            shoppingList[GroceryItem(name: itemName, quantity: itemQuantity, cost: itemCost)] = true
            
            //check the new balance and throw error if necessary
            if balance < 0 {throw GroceryTripError.totalExceedBudget}
        }
    }
    
    // function to remove an item from the cart
    func removeItemFromCart(groceryitem:GroceryItem) {
        
        // first find the index of that item and then remove using cart.remove()
        if let itemIndex = cart.index(of: groceryitem) {
            cart.remove(at:itemIndex)
            
            // unsure of below logic
            if shoppingList.contains(where: {$0.key == groceryitem}) {shoppingList[groceryitem]=false}
        }
    }
    
    // function to checkout
    func checkout() throws -> ([GroceryItem], Double){
        if taxRate <= 0.0 { throw GroceryTripError.zeroTaxRate}
        if balance < 0.0 { throw GroceryTripError.totalExceedBudget}
        
        //return the remaining items on the shopping list and the remaining budget in a tuple
        var itemsLeft = [GroceryItem]()
        for (item, isFound) in shoppingList {
            if isFound == true {
                shoppingList.removeValue(forKey: item)
                itemsLeft.append(item)
            }
        }
        return (itemsLeft, balance)
    }
    
    // update the tax rate and throw error when necessary
    func updateTaxRate (itemTaxrate:Double) throws {
        if (itemTaxrate < 0) {throw GroceryTripError.zeroTaxRate} else { taxRate = itemTaxrate}
        if (totalCost>userBudget) {throw GroceryTripError.totalExceedBudget}
        //totalCost is a get only property hence, cannot update it here, recheck logic
    }
}
