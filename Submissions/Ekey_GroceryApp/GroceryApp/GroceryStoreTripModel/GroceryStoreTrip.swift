//
//  GroceryStoreTrip.swift
//  GroceryApp
//
//  Created by Laurie Ekey on 3/5/19.
//

import Foundation

protocol GroceryStoreTripDelegate : class {
    func dataUpdated()
}
class GroceryStoreTrip {
    
    weak var delegate : GroceryStoreTripDelegate?
    
    private let persistence: GroceryListPersistence
    
    public private(set) var budget : Double = 0.0
    private var taxRate = 0.0     // percentage
    private var balance = 0.0     // read only computed value
    private var totalCost = 0.0   // read only computed value  Make optional value
    // dictionary of groceryItems bool = true if item was placed in cart
    private var shoppingList = [GroceryItem : Bool]()
    public private(set) var myCart = [GroceryItem]()
    
    
    
    init(persistence: GroceryListPersistence, budget: Double, groceryList: [GroceryItem], taxRate: Double = 0.0) {
        self.budget = budget
        self.taxRate = taxRate
        self.balance = budget - totalCost
        
        self.persistence = persistence
        myCart = persistence.readGroceryList()
        
        // Convert the array of GroceryList to a Dictionary and populate shoppingList
        // read groceryList into a dictionary  for each item in the groceryList, create a dictionary Item
        for item in groceryList {
            // since GroceryItem is hashable, the object can be a key
            shoppingList[item] = false
        }
//        var interimShoppingListSet: Set = Set(shoppingListArray)
//        func getShoppingList() -> [GroceryItem: Bool] {
//            let tuple = interimShoppingListSet.map { ($0, false)}
//            return Dictionary(uniqueKeysWithValues: tuple)
//        }
//        self.shoppingList = getShoppingList()
    }
    
    // can be nil
    func getGroceryCartItem(index: Int) throws -> GroceryItem? {
        
        if index < 0 || index >= myCart.count {
            throw GroceryStoreTripError.outOfBounds
        }
        
        return myCart[index]
    }
    
    func addGroceryItemToCart(_ groceryItem: GroceryItem, _ allowOverride: Bool = false) throws {
        
        // if the Item is already in the cart -- throw error
        guard myCart.isEmpty || myCart.contains(where:
            { $0.name.lowercased() != groceryItem.name.lowercased() })
            else {
            throw GroceryStoreTripError.itemExistsInList
        }
        
        // if item is on shopping list, continue - else- throw an error
        guard shoppingList.contains(where: { $0.key.name.lowercased() == groceryItem.name.lowercased() || allowOverride == true }) else {
            throw GroceryStoreTripError.itemNotOnList
        }
        
        // if  is on the shopping list and quantity is lower or allowable to be more, then continue - else throw error
        guard shoppingList.contains(where: { $0.key.name.lowercased() == groceryItem.name.lowercased() && $0.value == false || (allowOverride || groceryItem.quantity <= $0.key.quantity)}) else {
            throw GroceryStoreTripError.quantityIsMore
        }
        
        myCart.append(groceryItem)
        // indicate the grocery item was put into the cart
        shoppingList[groceryItem] = true
        
        

    }
    
    func removeGroceryItemFromCart(_ groceryItem: GroceryItem) -> Bool {
        // If item found in cart, remove from cart, and update the shoppingList Bool value to FALSE to indicate item not in Cart
        var itemFound = false
        
        // if the item is found in the cart - remove it.
        // because item is equatable
        if let index = myCart.index(of: groceryItem) {
            myCart.remove(at: index)
            itemFound = true
        }
        
        if shoppingList.contains(where: { $0.key == groceryItem }) {
            shoppingList[groceryItem] = false
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
             _ = try calculateBalance()
        } catch {
            throw error
        }
       
        
        if balance < 0.0 {
            throw GroceryStoreTripError.exceedsBudget
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
            throw GroceryStoreTripError.taxRateZero
        }
        totalCost = mySum + (mySum * taxRate)
        return totalCost
    }
    
    func calculateBalance() throws -> Double {
        do {
            let ttlCost = try calculateTtlCost()
            balance = budget - ttlCost
        } catch GroceryStoreTripError.taxRateZero {
            print("taxRate Zero")
            throw GroceryStoreTripError.taxRateZero
        } catch {
            print(error)
            throw error
        }
        
        return balance
    }
    
    func updateTaxRate(taxRate: Double) throws -> Bool{
        // If tax rate is ! > 0.0  throw error
        guard taxRate > 0.0 else {
            throw GroceryStoreTripError.taxRateZero
        }
        self.taxRate = taxRate
        _ = try calculateTtlCost()
        return true
    }
}
