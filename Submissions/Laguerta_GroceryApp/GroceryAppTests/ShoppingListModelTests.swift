import XCTest
@testable import GroceryApp

class ShoppingListModelTests: XCTestCase {

    var testShoppingListModel: ShoppingListModel!

    override func setUp() {
        testShoppingListModel = ShoppingListModel()

        continueAfterFailure = false
    }


    func test_addItemToShoppingList_CorrectlyAddsItem() {
        XCTAssertEqual(testShoppingListModel.listCount, 4)

        let expectedName = "test"
        let expectedQuantity = 1

        let actualShoppingListItem: GroceryItem? = testShoppingListModel.addItemToShoppingList(name: expectedName, quantity: expectedQuantity)

        XCTAssertEqual(testShoppingListModel.listCount, 5)
        XCTAssertEqual(actualShoppingListItem?.name, expectedName)
        XCTAssertEqual(actualShoppingListItem?.quantity, expectedQuantity)
        XCTAssertNil(actualShoppingListItem?.cost)
    }

    func test_validateName_EmptyString_ThrowsError() {
        let testString = ""

        XCTAssertThrowsError(try testShoppingListModel.validate(name: testString)) { error in
            XCTAssertEqual(error as? StringValidationError, StringValidationError.emptyString)
        }
    }

    func test_validateName_validName_ReturnsName() {
        let testString = "bananas"

        let actualResult = try? testShoppingListModel.validate(name: testString)

        XCTAssertEqual(actualResult, testString)
    }

    func test_validateQuantity_StringWithNonNumericCharacters_ThrowsError() {
        let testString = "123abc"

        XCTAssertThrowsError(try testShoppingListModel.validate(quantity: testString)) { error in
            XCTAssertEqual(error as? StringValidationError, StringValidationError.nonNumericCharacters)
        }
    }

    func test_validateName_validName_ReturnsQuantity() {
        let testString = "123"
        let expectedResult = Int(testString)
        let actualResult = try? testShoppingListModel.validate(quantity: testString)

        XCTAssertEqual(actualResult, expectedResult)
    }

    func test_groceryItemForRow_returnsCorrectGroceryItem() {
        let indexPath = IndexPath(row: 1, section: 0)
        let expectedGroceryItem = GroceryItem(name: "Oranges", quantity: 7)

        _ = testShoppingListModel.addItemToShoppingList(name: "bananas", quantity: 3)
        _ = testShoppingListModel.addItemToShoppingList(name: expectedGroceryItem.name, quantity: expectedGroceryItem.quantity)

        let actualResult = testShoppingListModel.groceryItemFor(row: indexPath.row)

        XCTAssertEqual(actualResult, expectedGroceryItem)
    }

    func test_groceryItemForRow_returnsNilWhenExceedingCount() {
        let indexPath = IndexPath(row: 5, section: 0)

        _ = testShoppingListModel.addItemToShoppingList(name: "Oranges", quantity: 7)


        let actualResult = testShoppingListModel.groceryItemFor(row: indexPath.row)

        XCTAssertNil(actualResult)
    }
}








