//
//  GroceryStoreTrip.swift
//  GroceryApp
//
//  Created by Laurie Ekey on 3/5/19.
//

import Foundation

class GroceryStoreTrip {
    
    public private(set) var budget : Double = 0.0
    private var taxRate = 0.0     // percentage
    private var balance = 0.0     // read only computed value
    private var totalCost = 0.0   // read only computed value  Make optional value
    // dictionary of groceryItems bool = true if item was placed in cart
    private var shoppingList = [GroceryItem : Bool]()
    public private(set) var myCart = [GroceryItem]()
    
    
    
    init(budget: Double, groceryList: [GroceryItem], taxRate: Double = 0.0) {
        self.budget = budget
        self.taxRate = taxRate
        self.balance = budget - totalCost
        // Convert the array of GroceryList to a Dictionary and populate shoppingList
        // read groceryList into a dictionary  for each item in the groceryList, create a dictionary Item
        for item in groceryList {
            // since GroceryItem is hashable, the object can be a key
            shoppingList[item] = false
        }
        // did this for testing .....  self.myCart = groceryList
    }
    
    func addGroceryItemToCart(_ groceryItem: GroceryItem, _ allowOverride: Bool = false) throws {
        var inList = false
        var error = GroceryTripError.none
        
        // Verify the item Name is not already in the cart..
        if !myCart.contains(where: { $0.name.lowercased() == groceryItem.name.lowercased() }) {
            // Laurie -- try to reduce this code..
            // if the item requested is in the shopping list, then add to cart
            for (gi, b) in shoppingList {
                // Is the grocery Item name in the shopping list?
                if gi.name.lowercased() == groceryItem.name.lowercased() && b == false {
                    if allowOverride || gi.quantity >= groceryItem.quantity {
                        myCart.append(groceryItem)
                        // indicate the grocery item was put into the cart
                        shoppingList[gi] = true
                        inList = true
                    } else {
                        error = GroceryTripError.quantityIsMore
                    }
                    break
                }
            }
            if (!inList) {
                if allowOverride {
                    myCart.append(groceryItem)
                }
                else {
                    error = GroceryTripError.itemNotOnList
                }
            }
        } else {
            // don't add item  - it already exists -- could update the quantity though ..
            error = GroceryTripError.itemExistsInList
        }
        
        if (error != GroceryTripError.none) {
            throw error
        }
    }
    
    func removeGroceryItemFromCart(_ groceryItem: GroceryItem) -> Bool {
        // If item found in cart, remove from cart, and update the shoppingList Bool value to FALSE to indicate item not in Cart
        
        // Laurie -- try to reduce this code..
        var itemFound = false
        var index = 0
        for item in myCart {
            if item.name.lowercased() == groceryItem.name.lowercased() {
                // found!  remove item from cart
                myCart.remove(at: index)
                index += 1
                for (gi, _) in shoppingList {
                    if gi.name.lowercased() == groceryItem.name.lowercased() {
                        // update shopping list to inidicate item not in cart anymore
                        shoppingList[gi] = false
                    }
                }
                itemFound = true
                break;
            }
        }
        
        return itemFound
    }
    
    func checkOut () throws -> (items: [GroceryItem], balance: Double) {
        // If tax rate = 0.0 then throw an error -- i.e. user never updated
        // If balance < 0, then throw an error
        // if no error --
        //   remove everything from shoppingCart where bool = true
        // returns tuple ( array of Groceryitems in Shopping List with bool value of FALSE and remaining budget)
        
        do {
             // checks if tax rate is zero -- if so throws
             try calculateBalance()
        } catch {
            throw error
        }
       
        
        if balance < 0.0 {
            throw GroceryTripError.exceedsBudget
        }
        
        var unPurchasedItems = [GroceryItem]()
        // remove everything from shoppingList that was purchased ( i.e. bool value = true )
        for (gi, b) in shoppingList {
            if b == true {
                // update shopping list to inidicate item not in cart anymore
                shoppingList.removeValue(forKey: gi)
                unPurchasedItems.append(gi)
            }
        }
        
        return (unPurchasedItems, balance)
    }
    
    
    // should use the reduce higher order function on the cart
    //   a higher order function that can accept functions or closures as arguments
    //   or return a function/closure
    //   a reduce function  combines all items in a collection to create a single new value
    func calculateTtlCost() throws -> Double {
        // totalCost = myCart.reduce(self.cost * self.quantity, +)
        // totalCost = myCart.reduce(0, { self.cost, self.quantity in self.cost * self.quantity})
        // NOTE:  sum up the values if cost is not nil and qty is not 0
        
        let mySum = self.myCart.reduce(0.0, { ( result: Double, groceryItem: GroceryItem) -> Double in
            return result + (groceryItem.cost! * Double(groceryItem.quantity))
        } )
        // If taxRate = 0  throw an error  else
        guard taxRate > 0.0 else {
            throw GroceryTripError.taxRateZero
        }
        totalCost = mySum + (mySum * taxRate)
        return totalCost
    }
    
    func calculateBalance() throws -> Double {
        do {
            let ttlCost = try calculateTtlCost()
            balance = budget - ttlCost
        } catch GroceryTripError.taxRateZero {
            print("taxRate Zero")
            throw GroceryTripError.taxRateZero
        } catch {
            print(error)
            throw error
        }
        
        return balance
    }
    
    func updateTaxRate(taxRate: Double) throws -> Bool{
        // If tax rate is ! > 0.0  throw error
        guard taxRate > 0.0 else {
            throw GroceryTripError.taxRateZero
        }
        self.taxRate = taxRate
        try calculateTtlCost()
        return true
    }
}
