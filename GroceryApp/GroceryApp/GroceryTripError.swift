//
//  GroceryTripError.swift
//  WeekFiveProject
//
//  Created by Melissa Bain on 3/2/19.
//  Copyright © 2019 MB Consulting. All rights reserved.
//

import Foundation

enum GroceryTripError: Error {
    case exceedsBudget      // If the total exceeds the budget
    case noItem             // If an item is selected that is not on the shopping list
    case exceedsAmount      // If the quantity exceeds the required amount
    case belowAmount        // If the quantity falls short of the required amount
    case noTax              // If the tax rate is 0.0
}
