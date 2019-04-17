import Foundation

protocol ShoppingListModelDelegate: class {
    func dataUpdated()
}

class ShoppingListModel {
    // MARK: - initialization
    init(persistence: GroceryItemPersistence){
        self.persistence = persistence
        shoppingList = persistence.groceryItems()
    }

    deinit {
        print("deinit ShoppingListModel")
    }

    // MARK: - private variables
    private let persistence: GroceryItemPersistence
    private var shoppingList: [GroceryItem] {
        didSet {
            persistence.write(shoppingList)
        }
    }

    // MARK: - public variables
    weak var delegate: ShoppingListModelDelegate?
    var listCount: Int { return shoppingList.count }

    func groceryItemFor(row: Int) -> GroceryItem? {
        guard row < listCount else { return nil }
        return shoppingList[row]
    }

    // MARK: - functions 
    func addItemToShoppingList(name: String, quantity: Int) -> GroceryItem {
        let groceryItem = GroceryItem(name: name, quantity: quantity)

        shoppingList.append(groceryItem)

        // let the controller know to update the table view
        delegate?.dataUpdated()

        return groceryItem
    }

    func validate(name: String?) throws -> String {
        return try Validation.notEmpty(name)
    }

    func validate(quantity: String?) throws -> Int {
        return try Validation.validInt(quantity)
    }
}
