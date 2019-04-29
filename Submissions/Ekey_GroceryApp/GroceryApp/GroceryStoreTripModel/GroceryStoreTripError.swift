//
//  GroceryStoreTripError.swift
//  GroceryApp
//
//  Created by johnekey on 3/5/19.
//

import Foundation

enum GroceryStoreTripError: Error {
    case exceedsBudget
    case itemNotOnList
    case quantityIsMore
    case taxRateZero
    case quantityCantBeZero
    case costCantBeNegative
    case itemExistsInList
    case outOfBounds
    case emptyString
    case nonIntegerValue
    case none
}

enum Action {
    case Add
    case Edit
    case Delete
    
}
