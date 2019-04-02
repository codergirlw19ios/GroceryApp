import Foundation

class GroceryTrip {
    private var budget = 0.0
    private var shoppingList: [GroceryItem: Bool]
    private var cart: [GroceryItem] = []
    private var taxRate = 0.0
    private let persistence: ShoppingListPersistence
    
    //: - Your class initializer will need the parameters for the user's budget (a dollar amount) and shopping list (an array of GroceryItem) and a tax rate with a default value of 0.0. You will need to convert the shoppingList array to a dictionary yourself. The rest that are not computed variables should default to logical values.
    //: - Converting the array of your own struct to a dictionary requires a few steps. The easiest way to do this is to first ensure your array contains unique values by initializing a Set from your array. Then map over the set and and return a tuple that represent the key-value pair that you want to be your dictionary item. Then use the Dictionary(uniqueKeysWithValues) initializer and pass in your array of tuples that you received from the map high order function.
    init(persistence: ShoppingListPersistence, budget: Double, taxRate: Double, shoppingListArray: [GroceryItem]) {
        self.persistence = persistence
        cart = persistence.shoppingList()
        self.budget = budget
        self.taxRate = taxRate
        var interimShoppingListSet: Set = Set(shoppingListArray)
        func getShoppingList() -> [GroceryItem: Bool] {
            let tuple = interimShoppingListSet.map { ($0, false)}
            return Dictionary(uniqueKeysWithValues: tuple)
        }
        self.shoppingList = getShoppingList()
    }
    
    //read only computed properties
    //Total cost and balance should be a read-only computed variables. The logic for total cost should use the reduce higher order function on the cart. If an item has no cost stored in the optional value, return the accumulating total. Otherwise, return the cost of the item multiplied times it's quantity added to the accumulating total.
    var totalCost: Double {
        get {
            //reduce function.
            var total:Double = cart.reduce(0) { x, y in
                y.cost != nil ? (x + (y.cost! * Double(y.quantity))) : x }
            total = total + (total * taxRate/100)
            print(total)
            return total
        }
    }
    //After you complete the reduce method, multiply the result with the tax rate and return the total as the computed value. The logic for balance should simply subtract the total from the budget.
    
    var balance: Double {
        get {
            return budget - totalCost
        }
    }
    
    //: - Write a function to add a GroceryItem to the cart, which can throw an GroceryTripError. Take in the parameters for cost, quantity and item.
    //: - - If the string does not match any of the GroceryItems' names in the shopping list dictionary, throw the appropriate error.
    //: - - If the quantity does not match the GroceryItem's quantity in the shopping list dictionary, throw the appropriate error.
    //: - - If the quantity matches, update the dictionary's boolean to true and add the GroceryItem with cost to the cart array. Check the new balance and throw an error if necessary.
    func addGroceryItemToCart(cost: Double, quantity: Int, name: String) throws {
        //If same item exists in cart then update quantity?
        let match: [GroceryItem: Bool] = shoppingList.filter{$0.key.name == name}
        if match.isEmpty {throw GroceryTripError.noMatchingItem}
        if (match.first!.key.quantity < quantity) { throw GroceryTripError.quantityNotMatching}
        shoppingList.updateValue(true, forKey: match.first!.key)
        var existingItemInCart = false
        for i in cart.indices {
            if (cart[i].name == name) {
                cart[i].quantity = cart[i].quantity + quantity
                existingItemInCart = true
            }
        }
        if (!existingItemInCart) {
            cart.append(GroceryItem(name: name, quantity: quantity, cost: cost))
        }
        //update the dictionary's boolean to true and add the GroceryItem with cost to the cart array. Check the new balance and throw an error if necessary.
        if (balance < 0) { throw GroceryTripError.totalExceedsBudget}
    }
    
    //: - Write another function to remove an item from the cart. Take in the parameter of GroceryItem. Remove it from the array, and find the matching item in the shopping list (if it exists) and update the dictionary's boolean to false.
    func removeGroceryItemFromCart(groceryItem: GroceryItem) throws {
        let match: [GroceryItem: Bool] = shoppingList.filter{$0.key ==  groceryItem}
        if match.isEmpty {throw GroceryTripError.noMatchingItem}
        shoppingList.updateValue(false, forKey: match.first!.key)
        for i in cart.indices {
            if (cart[i].name == groceryItem.name) {
            cart.remove(at: i)
            break
            }
        }
    }
    
    //: - Write a function to checkout that can throw an error. This function will return the remaining items on the shopping list and the remaining budget in a tuple. If the tax rate is 0.0, return the appropriate error. If the balance is negative, throw the appropriate error. Otherwise, remove everything from the shopping list whose boolean evaluates to true and return everything on the shopping list that wasn't purchased, and return the remaining available budget amount. Do not return a dictionary, but return an array of GroceryItem.
    
    func checkout() throws -> ([GroceryItem], Double)  {
        if taxRate == 0.0 {throw GroceryTripError.taxRateTooLow}
        if balance < 0 {throw GroceryTripError.totalExceedsBudget}
        let remainingItems = shoppingList.filter{$0.value == false}
        return (Array(remainingItems.keys), balance)
    }
    
    //: - Write another function to update the tax rate that can throw an error. Take in the appropriate parameter. Be sure to update the total. Throw an error if the new total exceeds the budget.
    func updateTaxRate(newTaxRate: Double) throws {
        if (newTaxRate <= 0.0) {throw GroceryTripError.taxRateTooLow}
        taxRate = newTaxRate
        if (totalCost > budget) {throw GroceryTripError.totalExceedsBudget}
    }
    
    func groceryItemFor(row : Int) -> GroceryItem? {
        guard row < cart.count else { return nil}
        return cart[row]
    }
    
    func getCartCount() -> Int {
        return cart.count
    }
    
    func validate(name: String?) throws -> String {
        let name = try validateNotEmpty(string: name)
        return name
    }
    
    func validate(quantity: String?) throws -> Int {
        let quantity = try validateNotEmpty(string: quantity)
        guard let intQuantity = Int(quantity) else {
            throw StringValidationError.nonNumericCharacters
        }
        return intQuantity
    }
    
    func validate(cost: String?) throws -> Double {
        let cost = try validateNotEmpty(string: cost)
        guard let doubleCost = Double(cost) else {
            throw StringValidationError.notValidFormat
        }
        return doubleCost
    }
    
}

extension GroceryTrip {
    private func validateNotEmpty(string: String?) throws -> String {
        guard let string = string, !string.isEmpty else {
            throw StringValidationError.emptyString
        }
        return string
    }
}

