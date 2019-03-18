import Foundation

class ShoppingListModel {

    private var shoppingList: [GroceryItem] = [
        GroceryItem(name: "Pears", quantity: 5),
        GroceryItem(name: "Oranges", quantity: 7),
        GroceryItem(name: "Grapes", quantity: 24),
        GroceryItem(name: "Pineapple", quantity: 1)
    ]

    var listCount: Int { return shoppingList.count }

    func groceryItemFor(row: Int) -> GroceryItem? {
        guard row < listCount else { return nil }
        return shoppingList[row]
    }

    func addItemToShoppingList(name: String, quantity: Int) -> GroceryItem {
        let groceryItem = GroceryItem(name: name, quantity: quantity)
        shoppingList.append(groceryItem)

        return groceryItem
    }

    func validate(name: String?) throws -> String {
        let name = try validateNotEmpty(string: name)

        return name
    }

    func validate(quantity: String?) throws -> Int {
        let quantityString = try validateNotEmpty(string: quantity)

        guard let quantityInt = Int(quantityString) else {
            throw StringValidationError.nonNumericCharacters
        }

        return quantityInt
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

enum StringValidationError: Error {
    case emptyString
    case nonNumericCharacters
}
