import Foundation

protocol ShoppingListModelDelegate:class {
    func dataUpdated()
}

class ShoppingListModel {
    weak var delegate: ShoppingListModelDelegate?
    private var shoppingList : [GroceryItem] = [GroceryItem(name: "banana", quantity: 12), GroceryItem(name: "milk", quantity: 3),
    GroceryItem(name: "bread", quantity: 2),
    GroceryItem(name: "yogurt", quantity: 6)]

    var listCount: Int { return shoppingList.count }

    func addItemToShoppingList(name: String, quantity: Int) -> GroceryItem {
        let groceryItem = GroceryItem(name: name, quantity: quantity)
        shoppingList.append(groceryItem)
        //let the controller know to update the table view
        delegate?.dataUpdated()
        
        return groceryItem
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
    
    func groceryItemFor(row : Int) -> GroceryItem? {
        guard row < shoppingList.count else { return nil}
        return shoppingList[row]
    }
}

extension ShoppingListModel {
    private func validateNotEmpty(string: String?) throws -> String {
        guard let string = string, !string.isEmpty else {
            throw StringValidationError.emptyString
        }
        return string
    }
}

enum StringValidationError:Error {
    case emptyString
    case nonNumericCharacters
}
