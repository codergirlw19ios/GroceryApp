//
//  GroceryAppTests.swift
//  GroceryAppTests
//
//  Created by Amanda Rawls on 2/26/19.
//

import XCTest
@testable import GroceryApp

class GroceryItemTests: XCTestCase {
    var testGroceryItem: GroceryItem!

    override func setUp() {
        testGroceryItem = GroceryItem("test", 1)
    }

    func test_GroceryItemInitializedWithCost_HasCorrectCostValue() {
        let expectedCost: Double = 1.04
        let actualGroceryItem = GroceryItem( "test",  1,  expectedCost)

        XCTAssertEqual(actualGroceryItem.cost, expectedCost)
    }

    func test_updateCost_HasCorrectCostValue_AfterUpdate() {
        let expectedCost: Double = 1.04
        
        do {
            try testGroceryItem.updateCost(cost: expectedCost)
        } catch {}
        
        XCTAssertEqual(testGroceryItem.cost, expectedCost)
    }

    func test_updateQuantity_HasCorrectValue_AfterUpdate() {
        let expectedQuantity: Int = 4
        do {
            try testGroceryItem.updateQuantity(quantity: expectedQuantity)
        } catch {}
    
        XCTAssertEqual(testGroceryItem.quantity, expectedQuantity)
    }
}
