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
    
    var description: String {
        switch self {
        case .exceedsBudget:
            return "Exceeds Budget"
        case .itemNotOnList:
            return "Item is Not in the Grocery List"
        case .quantityIsMore:
            return "Item Quantity exceeds the Required Amount"
        case .taxRateZero:
            return "Tax Rate Error"
        case .quantityCantBeZero:
            return "Quantity cannot be zero"
        case .costCantBeNegative:
            return "Item cost cannot be negative"
        case .itemExistsInList:
            return "Item already exists in the Grocery List"
        case .outOfBounds:
            return "Out of bounds"
        case .emptyString:
            return "Empty string"
        case .nonIntegerValue:
            return "Non integer value"
        case .none:
            return "None"
        }
    }
}

enum Action {
    case Add
    case Edit
    case Delete
    
}
