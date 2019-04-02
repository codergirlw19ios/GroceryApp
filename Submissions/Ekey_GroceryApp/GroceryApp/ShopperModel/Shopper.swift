import Foundation

protocol ShopperDelegate : class {
    func dataUpdated()
}

class Shopper {
    
    weak var delegate : ShopperDelegate?
    
    private let persistence: GroceryListPersistence
    
    public private(set) var myGroceryList: [GroceryItem] {
        didSet {
            persistence.writeGroceryList(myGroceryList)
        }
    }
    
    init(persistence: GroceryListPersistence) {
        self.persistence = persistence
        // read the data from the file and initialize list
        myGroceryList = persistence.readGroceryList()
    }
//    public private(set) var myGroceryList = [
//        GroceryItem( "Milk", 1, 2.50),
//        GroceryItem( "Yogurt",  1,  2.50),
//        GroceryItem( "Apples",  4),
//        GroceryItem( "Bread",  1),
//        GroceryItem( "Lettuce",  1,  2.50),
//        GroceryItem( "Cucumber",  1,  2.50),
//        GroceryItem( "Tomato",  1)
//    ]
    
    // Add a unique groceryItem to the users list
    func addGroceryItemToList(_ groceryItem: GroceryItem ) throws {
        // check the list to see if item already exists, if so, give user a message
        // else add the item to the list.
        if !myGroceryList.contains(where: { $0.name.lowercased() == groceryItem.name.lowercased() }) {
            myGroceryList.append(groceryItem)
        } else {
            throw GroceryStoreTripError.itemExistsInList
        }
        
        // notify whoever is listening to the shoppperDelegate that we updated the data
        delegate?.dataUpdated()
        
    }
    
    
    // can be nil
    func getGroceryItem(index: Int) throws -> GroceryItem? {
        
        if index < 0 || index >= myGroceryList.count {
            throw ShopperError.OutOfBounds
        }
    
        return myGroceryList[index]
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
    case OutOfBounds
}
