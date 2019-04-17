import Foundation
class StateController {
    static let shared = StateController(persistence: GroceryItemPersistence(filename: "ShoppingList"))
    
    var shoppingList: [GroceryItem] {
        didSet {
            persistence.write(shoppingList)
        }
    }
    private let persistence: GroceryItemPersistence
    private init(persistence: GroceryItemPersistence){
        self.persistence = persistence
        shoppingList = persistence.groceryItems()
    }
    
    
}
