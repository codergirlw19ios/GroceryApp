import Foundation

class Shopper {
    
    public private(set) var myGroceryList = [GroceryItem]()
    
    // Add a unique groceryItem to the users list
    func addGroceryItemToList(_ groceryItem: GroceryItem ) throws {
        // check the list to see if item already exists, if so, give user a message
        // else add the item to the list.
        if !myGroceryList.contains(where: { $0.name.lowercased() == groceryItem.name.lowercased() }) {
            myGroceryList.append(groceryItem)
        } else {
            throw GroceryTripError.itemExistsInList
        }
        
    }
    
    // verify string is not empty
    func validateString(name: String?) throws {
        guard let stringName = name, !stringName.isEmpty else {
            throw ShopperError.EmptyString
        }
    }

    // Verify string is not empty and only contains integers
    func validateInt(qty: String?) throws -> Int {
        try validateString(name: qty)
        
        guard let quantity = Int(qty!) else {
            throw ShopperError.NonIntegerValue
        }
        return quantity
    }
}

enum ShopperError: Error {
    case EmptyString
    case NonIntegerValue
}
