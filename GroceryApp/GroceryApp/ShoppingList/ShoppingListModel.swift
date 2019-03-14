import Foundation

protocol ShoppingListModelDelegate: class {
    func dataUpdated()
}

class ShoppingListModel {
    weak var delegate: ShoppingListModelDelegate?

    private let persistence: ShoppingListPersistence
    
    private var shoppingList: [GroceryItem] {
        didSet {
            persistence.write(shoppingList)
        }
    }
    
    var listCount: Int { return shoppingList.count }

    init(persistence: ShoppingListPersistence) {
        self.persistence = persistence
        shoppingList = persistence.shoppingList()
    }

    func groceryItemFor(row: Int) -> GroceryItem? {
        guard row < listCount else { return nil }
        return shoppingList[row]
    }

    func addItemToShoppingList(name: String, quantity: Int) -> GroceryItem {
        let groceryItem = GroceryItem(name: name, quantity: quantity)

        shoppingList.append(groceryItem)

        // let the controller know to update the table view
        delegate?.dataUpdated()

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

    deinit {
        print("deinit ShoppingListModel")
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
