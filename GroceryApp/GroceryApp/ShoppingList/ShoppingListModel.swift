import Foundation

protocol ShoppingListModelDelegate: class {
    func dataUpdated()
}

class ShoppingListModel {
    // MARK: - initialization
    init(stateController: StateController){
        self.stateController = stateController
    }

    deinit {
        print("deinit ShoppingListModel")
    }

    // MARK: - private variables
    private let stateController: StateController
    private var shoppingList: [ShoppingListItem] { return stateController.shoppingList }

    // MARK: - public variables
    weak var delegate: ShoppingListModelDelegate?
    var listCount: Int { return shoppingList.count }

    func shoppingListItem(row: Int) -> ShoppingListItem? {
        guard row < listCount else { return nil }
        return shoppingList[row]
    }

    // MARK: - functions 
    func addItemToShoppingList(name: String, quantity: Int) -> ShoppingListItem {
        let groceryItem = GroceryItem(name: name, quantity: quantity)
        let shoppingListItem = ShoppingListItem(groceryItem: groceryItem, inCart: false)
        stateController.shoppingList.append(shoppingListItem)

        // let the controller know to update the table view
        delegate?.dataUpdated()

        return shoppingListItem
    }

    func validate(name: String?) throws -> String {
        return try Validation.notEmpty(name)
    }

    func validate(quantity: String?) throws -> Int {
        return try Validation.validInt(quantity)
    }
}
