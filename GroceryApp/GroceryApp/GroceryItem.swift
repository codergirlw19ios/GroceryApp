//
//  GroceryItem.swift
//  WeekFiveProject
//
//  Created by Melissa Bain on 3/2/19.
//  Copyright © 2019 MB Consulting. All rights reserved.
//

import Foundation

struct GroceryItem: Hashable {
    let itemName: String
    var quantity: Int
    var cost: Double?
    
    init(itemName: String, quantity: Int, cost: Double? = nil) {
        self.itemName = itemName
        self.quantity = quantity
        self.cost = cost
    }
    
    mutating func update(cost: Double) {
        self.cost = cost
    }
    
    mutating func update(quantity: Int) {
        self.quantity = quantity
    }
}
