//
//  StringValidation.swift
//  GroceryApp
//
//  Created by johnekey on 4/9/19.
//

import Foundation

class Validation {
    
    // verify string is not empty
    static func validateString(stringValue: String?) throws {
        guard let stringName = stringValue, !stringName.isEmpty else {
            throw StringValidationError.emptyString
        }
    }
    
    // Verify string is not empty and only contains integers
    static func validateInt(intValue: String?) throws -> Int {
        try validateString(stringValue: intValue)
        
        guard let int = Int(intValue!) else {
            throw StringValidationError.nonNumericCharacters
        }
        return int
    }
    
    static func validateDouble(doubleValue: String?) throws -> Double {
        try validateString(stringValue: doubleValue)
        
        guard let dbl = Double(doubleValue!) else {
            throw StringValidationError.nonNumericCharacters
        }
        return dbl
    }
    
    static func currency(from number: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        return currencyFormatter.string(for: number) ?? String(number)
    }
    static func percent(from number: Double) -> String {
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .percent
        return percentFormatter.string(for: number) ?? String(number)
    }
}

enum StringValidationError: Error {
    case emptyString
    case nonNumericCharacters
}
