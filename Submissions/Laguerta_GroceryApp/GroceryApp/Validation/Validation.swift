//
//  StringValidation.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/2/19.
//

import Foundation
class Validation {
    static func validInt(_ string: String?) throws -> Int {
        let intString = try notEmpty(string)

        guard let int = Int(intString) else {
            throw StringValidationError.nonNumericCharacters
        }

        return int
    }

    static func validDouble(_ string: String?) throws -> Double {
        let doubleString = try notEmpty(string)

        guard let double = Double(doubleString) else {
            throw StringValidationError.nonNumericCharacters
        }

        return double
    }

    static func notEmpty(_ string: String?) throws -> String {
        guard let string = string, !string.isEmpty else {
            throw StringValidationError.emptyString
        }

        return string
    }

    static func currency(from number: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        return currencyFormatter.string(for: number) ?? String(number)
    }
}

enum StringValidationError: Error {
    case emptyString
    case nonNumericCharacters
}
