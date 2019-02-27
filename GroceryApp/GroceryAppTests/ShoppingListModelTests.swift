import XCTest
@testable import GroceryApp

class ShoppingListModelTests: XCTestCase {

    var testShoppingListModel: ShoppingListModel!

    override func setUp() {
        testShoppingListModel = ShoppingListModel()

        continueAfterFailure = false
    }


    func test_addItemToShoppingList_CorrectlyAddsItem() {
        XCTAssertEqual(testShoppingListModel.listCount, 0)

        let expectedName = "test"
        let expectedQuantity = 1

        let actualShoppingListItem: GroceryItem = testShoppingListModel.addItemToShoppingList(name: expectedName, quantity: expectedQuantity)

        XCTAssertEqual(testShoppingListModel.listCount, 1)
        XCTAssertEqual(actualShoppingListItem.name, expectedName)
        XCTAssertEqual(actualShoppingListItem.quantity, expectedQuantity)
        XCTAssertNil(actualShoppingListItem.cost)
    }
}
