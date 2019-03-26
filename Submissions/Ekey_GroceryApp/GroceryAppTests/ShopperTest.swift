//
//  ShopperTest.swift
//  GroceryAppTests
//
//  Created by johnekey on 3/5/19.
//

import XCTest
@testable import GroceryApp

class ShopperTest: XCTestCase {

    var sue : Shopper!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sue = Shopper()
        do {
            try sue.addGroceryItemToList(GroceryItem("Bread",  1))
            try sue.addGroceryItemToList(GroceryItem("Milk",  1))

        } catch {
            print(error)   // itemExistsInList
        }
    }

    func test_addGroceryItemToList() {
        // This is an example of a functional test case.
        let expectedOutput = sue.myGroceryList.count + 1
        
        do {
            try sue.addGroceryItemToList(GroceryItem( "chips",  1))
            
        } catch {
            print(error)   // itemExistsInList
        }
        
        let actualOutput = sue.myGroceryList.count
        
        XCTAssertEqual(actualOutput, expectedOutput)
    }
    
    func test_addGroceryItemToList_Error() {
        // This is an example of a functional test case.
        let expectedOutput = GroceryTripError.itemExistsInList
        
        XCTAssertThrowsError(try sue.addGroceryItemToList(GroceryItem( "Bread",  1))) { error in XCTAssertEqual(error as! GroceryTripError, expectedOutput)
        }
    }

    func test_getGroceryItem() {
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
