//
//  GroceryStoreTripTests.swift
//  GroceryAppTests
//
//  Created by johnekey on 3/5/19.
//

import XCTest
@testable import GroceryApp

class GroceryStoreTripTests: XCTestCase {

    var sue : Shopper!
    var testGroceryItem: GroceryItem!
    var myTrip: GroceryStoreTrip!

    override func setUp() {
        sue = Shopper(persistence: GroceryListPersistence())
        testGroceryItem = GroceryItem( "test",  1)
        
        do {
            try sue.addGroceryItemToList(GroceryItem( "bread",  1))
            try sue.addGroceryItemToList(GroceryItem( "Yogurt", 4))
            try sue.addGroceryItemToList(GroceryItem( "Apples", 4))
        } catch {
            print(error)   // itemExistsInList
        }
        
        // sets tax rate = 0.0
        myTrip = GroceryStoreTrip(persistence: GroceryListPersistence(), budget: 100.00, groceryList: sue.myGroceryList)
        
        do {
            // allow override of adding milk since not on groceryList
            try myTrip.addGroceryItemToCart(GroceryItem( "Milk", 1, 2.50), true)
            try myTrip.addGroceryItemToCart(GroceryItem("Bread", 1,  2.50))
            
        } catch {
            print(error)
        }
    }

  
    func test_AddGroceryItemToCart_Count() {
        var count = myTrip.myCart.count
        XCTAssertEqual(count, 2)
        let expectedOutput = myTrip.myCart.count + 1
        // try? if throws error will be nil
        try? myTrip.addGroceryItemToCart(GroceryItem("Hamburger",  1,  2.50), true)
        count = myTrip.myCart.count
        XCTAssertEqual(count, expectedOutput)
    }
    
    func test_RemoveGroceryItemToCart_Count() {
        
        XCTAssertEqual(myTrip.myCart.count, 2)
        let expectedOutput = myTrip.myCart.count - 1
        
        _ = myTrip.removeGroceryItemFromCart(GroceryItem( "Milk",  1,  2.50))
        
        XCTAssertEqual(myTrip.myCart.count, expectedOutput)
    }
    
    
    
    func test_calculateTotalCost_TaxRateZeroError() {
        
        // tax rate = 0  throws
        // tax rate changes -- new costCalculation
        
        let expectedOutput = GroceryStoreTripError.taxRateZero
        
        XCTAssertThrowsError(try myTrip.calculateTtlCost()) { error in XCTAssertEqual(error as! GroceryStoreTripError, expectedOutput)
        }
    }
    
    func test_calculateTotalCost() {
        
        let expectedOutput = 5.25  // ( 2.5 x 2 + 2.5 x 2 x .05)
        var actualOutput = 0.0
        
        // try? if throws error will be nil
        _ = try? myTrip.updateTaxRate(taxRate: 0.05)   // 5 %
        // try if throws code will crash
        actualOutput = try! myTrip.calculateTtlCost()
        
        
        XCTAssertEqual(actualOutput, expectedOutput)
        
    }
    
    func test_calculateBalance_TaxRateZeroError() {
        
        // if tax rate 0 then calcTtlCost throws and calcBalance propogates an error
        
        let expectedOutput = GroceryStoreTripError.taxRateZero
        
        XCTAssertThrowsError(try myTrip.calculateBalance()) { error in XCTAssertEqual(error as! GroceryStoreTripError, expectedOutput)
        }
    }
    func test_calculateBalance() {
        // if tax rate 0 then calcTtlCost throws and calcBalance propogates an error
        XCTAssertEqual(myTrip.myCart.count, 2)
        let expectedOutput = 100.0 - 5.25
        var actualOutput = 0.0
        
        // try? if throws error will be nil
        _ =  try? myTrip.updateTaxRate(taxRate: 0.05)   // 5 %
       // try! if throws code will crash
        actualOutput = try! myTrip.calculateBalance()
       
        XCTAssertEqual(actualOutput, expectedOutput)
    }
    
    func test_updateTaxRate_Negative() {
        // tax rate negative -- throw
        // set tax rate
        // calcTtlCost
        // if tax rate 0 then calcTtlCost throws and calcBalance propogates an error
        
        let expectedOutput = GroceryStoreTripError.taxRateZero
        
        XCTAssertThrowsError(try myTrip.updateTaxRate(taxRate: -0.02)) { error in XCTAssertEqual(error as! GroceryStoreTripError, expectedOutput)
        }

    }
    
    func test_updateTaxRate() {
        XCTAssertEqual(myTrip.myCart.count, 2)
        let expectedOutput = true
        var actualOutput = false
        
        actualOutput = try! myTrip.updateTaxRate(taxRate: 0.05)   // 5 %
        
        XCTAssertEqual(actualOutput, expectedOutput)
    }
    
    func test_checkout() {
        // If tax rate = 0.0 then throw an error -- i.e. user never updated
        // If balance < 0, then throw an error
        // if no error --
        //   remove everything from shoppingCart where bool = true
        // returns tuple ( array of Groceryitems in Shopping List where bool value = FALSE and remaining budget)
        XCTAssertEqual(myTrip.myCart.count, 2)
        let expectedOutput = (items: [GroceryItem( "Yogurt",  4),
                                      GroceryItem( "Apples",  4)], balance: 94.75)
        
        _ = try? myTrip.updateTaxRate(taxRate: 0.05)   // 5 %
        var actualOutput = try! myTrip.checkOut()
        
//        XCTAssertEqual(actualOutput, expectedOutput)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
