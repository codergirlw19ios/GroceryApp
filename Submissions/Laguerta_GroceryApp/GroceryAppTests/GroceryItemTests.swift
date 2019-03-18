import XCTest
@testable import GroceryApp

// Your GroceryItem will have
//a name (a string),
//a quantity (an int),
//and a cost (a dollar amount).
//The shopping list will not know the cost of the items before the trip, so make cost an optional value. Write a mutating function that will update cost, and another to update quantity in case the grocery store does not have the items in stock.

class GroceryItemTests: XCTestCase {
    var testGroceryItem: GroceryItem!

    override func setUp() {
        testGroceryItem = GroceryItem(name: "test", quantity: 1)
    }

    func test_GroceryItemInitializedWithNoCost_HasNilForCost() {
        XCTAssertNil(testGroceryItem.cost)
    }

    func test_GroceryItemInitializedWithCost_HasCorrectCostValue() {
        let expectedCost: Double = 1.04
        let actualGroceryItem = GroceryItem(name: "test", quantity: 1, cost: expectedCost)

        XCTAssertEqual(actualGroceryItem.cost, expectedCost)
    }
//
    func test_updateCost_HasCorrectCostValue_AfterUpdate() {
        let expectedCost: Double = 1.04
        testGroceryItem.update(cost: expectedCost)
//
        XCTAssertEqual(testGroceryItem.cost, expectedCost)
    }
//
    func test_updateQuantity_HasCorrectValue_AfterUpdate() {
        let expectedQuantity: Int = 4
        testGroceryItem.update(quantity: expectedQuantity)

        XCTAssertEqual(testGroceryItem.quantity, expectedQuantity)
    }
}
