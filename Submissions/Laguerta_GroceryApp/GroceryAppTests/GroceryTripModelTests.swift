//
//  GroceryTripModelTests.swift
//  GroceryAppTests
//
//  Created by Sandra Laguerta on 3/18/19.
//

import XCTest
@testable import GroceryApp

class GroceryTripModelTests: XCTestCase {
    var testGroceryTripModel: GroceryTrip!
    var pears =  GroceryItem(name: "Pears", quantity: 5)
    var oranges = GroceryItem(name: "Oranges", quantity: 7)
    var grapes = GroceryItem(name: "Grapes", quantity: 24)
    var pineapple = GroceryItem(name: "Pineapple", quantity: 1)
    //var testGroceryTripModel = GroceryTrip(budget: 150.00, shoppingListArray: ShoppingListModel.init(),  taxRate: 5.0)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testGroceryTripModel = GroceryTrip(budget: 150.00, shoppingListArray: [pears, oranges, grapes, pineapple],  taxRate: 5.0)
        
        continueAfterFailure = false
    }

    func test_AddToCart_CorrectlyAddsToCart() {
        try? testGroceryTripModel?.addToCart(cost: 1.20, quantity: 5, groceryItem: pears)
        XCTAssertEqual(testGroceryTripModel.cartCount, 1)
    }

}
