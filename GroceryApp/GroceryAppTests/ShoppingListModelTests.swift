import XCTest
@testable import GroceryApp

class ShoppingListModelTests: XCTestCase {

    var testShoppingListModel: ShoppingListModel!

    override func setUp() {
        testShoppingListModel = ShoppingListModel(persistence: GroceryItemPersistence("ShoppingList"))

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
    
    func test_validateName_EmptyString_ThrowsError() {
        let testString = ""

        XCTAssertThrowsError(try testShoppingListModel.validate(name: testString)) { error in
            XCTAssertEqual(error as? StringValidationError, StringValidationError.emptyString)
        }
    }
    
    func test_validateNameReturnsName() {
        let testString = "milk"
        let actualResult = try? testShoppingListModel.validate(name: testString)
        XCTAssertEqual(actualResult, testString)
    }
    
    
    func test_validateQuantityReturnsName() {
        let testString = "123"
        let actualResult = try? testShoppingListModel.validate(quantity: testString)
        XCTAssertEqual(actualResult, Int(testString))
    }
    
    func test_groceryItemForRowReturnsCorrectGroceryItemForRow() {
        let indexPath = IndexPath(row: 1, section: 0)
//        let firstGroceryItem = GroceryItem(name: "bananas", quantity: 3)
        let expectedGroceryItem = GroceryItem(name: "pears", quantity: 6)
        _ = testShoppingListModel.addItemToShoppingList(name: "bananas", quantity: 3)
        _ = testShoppingListModel.addItemToShoppingList(name: expectedGroceryItem.name, quantity: expectedGroceryItem.quantity)
        let actualResult = testShoppingListModel.groceryItemFor(row: indexPath.row)
        XCTAssertEqual(actualResult, expectedGroceryItem)
    }
    
}
