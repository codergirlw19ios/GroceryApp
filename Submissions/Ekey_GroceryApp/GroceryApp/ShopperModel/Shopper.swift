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

}
