//
//  GroceryTripError.swift
//  GroceryApp
//
//  Created by Sandra Laguerta on 3/18/19.
//

import Foundation

enum GroceryTripError: Error, Equatable {
    case totalExceedsBudget
    case excessQuantity
    case shortQuantity
    case noTax
    case unplannedGroceryItem
}
