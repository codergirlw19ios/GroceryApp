import Foundation

class ShoppingListModel {
    private var shoppingList = [GroceryItem]()

    var listCount: Int { return shoppingList.count }

    func addItemToShoppingList(name: String, quantity: Int) -> GroceryItem {
        let groceryItem = GroceryItem(itemName: name, quantity: quantity)
        shoppingList.append(groceryItem)

        return groceryItem
    }
}
