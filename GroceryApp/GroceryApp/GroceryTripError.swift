//
//  GroceryTripError.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 3/2/19.
//

import Foundation

enum GroceryTripError: Error {
    case noMatchingItem
    case quantityNotMatching
    case totalExceedsBudget
    case notEnoughQuantitySelected
    case taxRateTooLow
}
