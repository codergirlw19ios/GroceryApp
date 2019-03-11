//
//  GroceryTripError.swift
//  GroceryApp
//
//  Created by Messaging on 3/6/19.
//

import Foundation


enum GroceryTripError: Error {
    case totalExceedBudget
    case itemNotFound
    case qtyExceedAmt
    case qtyShortOfReqAmt
    case zeroTaxRate
}
