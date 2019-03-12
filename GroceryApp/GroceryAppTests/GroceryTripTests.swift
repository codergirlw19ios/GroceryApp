//
//  GroceryTripTests.swift
//  GroceryAppTests
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 3/2/19.
//

import XCTest
@testable import GroceryApp

class GroceryTripTests: XCTestCase {
    var testGroceryTrip: GroceryTrip!
    var breadItem = GroceryItem(name: "bread", quantity: 1)
    var cerealItem = GroceryItem(name: "cereal", quantity: 1)
    var milkItem = GroceryItem(name: "milk", quantity: 2)
    var cerealItemQuantityTwo = GroceryItem(name: "cereal", quantity: 2)
    var cerealItemQuantityThree = GroceryItem(name: "cereal", quantity: 3)

    override func setUp() {
        
    }

    func testTotalCostAndBalanceWithOneItemInCart() throws {
        testGroceryTrip = GroceryTrip(budget: 120.00, taxRate: 5.5, shoppingListArray: [breadItem, cerealItem, milkItem])
        try testGroceryTrip.addGroceryItemToCart(cost: 2.0, quantity: 1, name: "bread")
        let expectedTotalCost = 2 + (2 * 0.055)
        XCTAssertEqual(testGroceryTrip.totalCost, expectedTotalCost)
        XCTAssertEqual(testGroceryTrip.balance,120 - expectedTotalCost)
    }
    
    func testAddingGroceryItemNotOnShoppingListThrowsError() throws {
        testGroceryTrip = GroceryTrip(budget: 120.00, taxRate: 5.5, shoppingListArray: [breadItem, cerealItem, milkItem])
        XCTAssertThrowsError(try testGroceryTrip.addGroceryItemToCart(cost: 2.0, quantity: 1, name: "cheese")) {
            error in
    
            XCTAssertEqual(error as! GroceryTripError, GroceryTripError.noMatchingItem) }
    }
    
    func testTotalCostAndBalanceWithTwoItemsInCart() throws {
        testGroceryTrip = GroceryTrip(budget: 120.00, taxRate: 5.5, shoppingListArray: [breadItem, cerealItem, milkItem])
        try testGroceryTrip.addGroceryItemToCart(cost: 2.0, quantity: 1, name: "bread")
        try testGroceryTrip.addGroceryItemToCart(cost: 4.0, quantity: 1, name: "cereal")
        let expectedTotalCost = 6 + (6 * 0.055)
        XCTAssertEqual(testGroceryTrip.totalCost, expectedTotalCost)
        XCTAssertEqual(testGroceryTrip.balance,120 - expectedTotalCost)
    }
    
    func test_removeGroceryItemFromCart() throws {
        testGroceryTrip = GroceryTrip(budget: 120.00, taxRate: 5.5, shoppingListArray: [breadItem, cerealItem, milkItem])
        try testGroceryTrip.addGroceryItemToCart(cost: 2.0, quantity: 1, name: "bread")
        try testGroceryTrip.addGroceryItemToCart(cost: 4.0, quantity: 1, name: "cereal")
        var expectedTotalCost = 6 + (6 * 0.055)
        XCTAssertEqual(testGroceryTrip.totalCost, expectedTotalCost)
        XCTAssertEqual(testGroceryTrip.balance,120 - expectedTotalCost)
        try testGroceryTrip.removeGroceryItemFromCart(groceryItem: breadItem)
        expectedTotalCost = 4 + (4 * 0.055)
        XCTAssertEqual(testGroceryTrip.totalCost, expectedTotalCost)
        XCTAssertEqual(testGroceryTrip.balance,120 - expectedTotalCost)
    }
    
    func test_removeGroceryItemWithMultipleQuantityFromCart() throws {
        testGroceryTrip = GroceryTrip(budget: 120.00, taxRate: 5.5, shoppingListArray: [breadItem, cerealItemQuantityTwo])
        try testGroceryTrip.addGroceryItemToCart(cost: 2.0, quantity: 1, name: "bread")
        try testGroceryTrip.addGroceryItemToCart(cost: 4.0, quantity: 2, name: "cereal")
        var expectedTotalCost = 10 + (10 * 0.055)
        XCTAssertEqual(testGroceryTrip.totalCost, expectedTotalCost)
        XCTAssertEqual(testGroceryTrip.balance,120 - expectedTotalCost)
        try testGroceryTrip.removeGroceryItemFromCart(groceryItem: cerealItemQuantityTwo)
        expectedTotalCost = 2 + (2 * 0.055)
        XCTAssertEqual(testGroceryTrip.totalCost, expectedTotalCost)
        XCTAssertEqual(testGroceryTrip.balance,120 - expectedTotalCost)
    }
    
    func testCheckout() throws {
        testGroceryTrip = GroceryTrip(budget: 120.00, taxRate: 5.5, shoppingListArray: [breadItem, cerealItem, milkItem])
        try testGroceryTrip.addGroceryItemToCart(cost: 2.0, quantity: 1, name: "bread")
        try testGroceryTrip.addGroceryItemToCart(cost: 4.0, quantity: 1, name: "cereal")
        let expectedTotalCost = 6 + (6 * 0.055)
        XCTAssertEqual(testGroceryTrip.totalCost, expectedTotalCost)
        XCTAssertEqual(testGroceryTrip.balance,120 - expectedTotalCost)
        let result = try testGroceryTrip.checkout()
        XCTAssertEqual(120 - expectedTotalCost, result.1)
        XCTAssertEqual(milkItem, (result.0)[0])
    }
    
    func test_updateTaxRate() throws {
        testGroceryTrip = GroceryTrip(budget: 120.00, taxRate: 5.5, shoppingListArray: [breadItem, cerealItem, milkItem])
        try testGroceryTrip.addGroceryItemToCart(cost: 2.0, quantity: 1, name: "bread")
        try testGroceryTrip.addGroceryItemToCart(cost: 4.0, quantity: 1, name: "cereal")
        var expectedTotalCost = 6 + (6 * 0.055)
        XCTAssertEqual(testGroceryTrip.totalCost, expectedTotalCost)
        try testGroceryTrip.updateTaxRate(newTaxRate: 6.0)
        expectedTotalCost = 6 + (6 * 0.06)
        XCTAssertEqual(testGroceryTrip.totalCost, expectedTotalCost)
    }
    
    func test_updateTaxRateNegative() throws {
        testGroceryTrip = GroceryTrip(budget: 120.00, taxRate: 5.5, shoppingListArray: [breadItem, cerealItem, milkItem])
        try testGroceryTrip.addGroceryItemToCart(cost: 2.0, quantity: 1, name: "bread")
        try testGroceryTrip.addGroceryItemToCart(cost: 4.0, quantity: 1, name: "cereal")
        XCTAssertThrowsError(try testGroceryTrip.updateTaxRate(newTaxRate: -2.0))
    }
    
    func test_updateTaxRateBalanceTooLow() throws {
        testGroceryTrip = GroceryTrip(budget: 8.00, taxRate: 5.5, shoppingListArray: [breadItem, cerealItem, milkItem])
        try testGroceryTrip.addGroceryItemToCart(cost: 2.0, quantity: 1, name: "bread")
        try testGroceryTrip.addGroceryItemToCart(cost: 4.0, quantity: 1, name: "cereal")
        XCTAssertThrowsError(try testGroceryTrip.updateTaxRate(newTaxRate: 50.0))
        
    }
    
    func testTotalCostAndBalanceWithSameItemTwiceInCart() throws {
        testGroceryTrip = GroceryTrip(budget: 120.00, taxRate: 5.5, shoppingListArray: [breadItem, cerealItemQuantityThree])
        try testGroceryTrip.addGroceryItemToCart(cost: 2.0, quantity: 1, name: "bread")
        try testGroceryTrip.addGroceryItemToCart(cost: 4.0, quantity: 2, name: "cereal")
        try testGroceryTrip.addGroceryItemToCart(cost: 4.0, quantity: 1, name: "cereal")
        let expectedTotalCost = 14 + (14 * 0.055)
        XCTAssertEqual(testGroceryTrip.totalCost, expectedTotalCost)
        XCTAssertEqual(testGroceryTrip.balance,120 - expectedTotalCost)
    }
}
