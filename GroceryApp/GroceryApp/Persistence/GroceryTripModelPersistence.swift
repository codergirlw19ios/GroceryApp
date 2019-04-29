//
//  GroceryTripModelPersistence.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/22/19.
//

import Foundation

class GroceryTripModelPersistence: Persistence {

    // read JSON from file
    func data() -> GroceryTripModelData? {
        return super.read()
    }

    // write JSON to file
    func write(_ data: GroceryTripModelData) {
        super.write(data)
    }
}
