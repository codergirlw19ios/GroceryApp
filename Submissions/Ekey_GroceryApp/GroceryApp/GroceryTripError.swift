//
//  GroceryTripError.swift
//  GroceryApp
//
//  Created by johnekey on 3/5/19.
//

import Foundation

enum GroceryTripError: Error {
    case exceedsBudget
    case itemNotOnList
    case quantityIsMore
    case taxRateZero
    case quantityCantBeZero
    case costCantBeNegative
    case itemExistsInList
    case none
}
