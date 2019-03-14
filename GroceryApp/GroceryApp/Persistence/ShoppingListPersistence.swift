//
//  ShoppingListPersistence.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 3/13/19.
//

import Foundation

class ShoppingListPersistence {
    private let fileName = "ShoppingList"
    private let fileURL: URL
    private let type = "json"

    init() {
        fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(fileName, isDirectory: false)
            .appendingPathComponent(type)
    }

    // read JSON from file
    func shoppingList() -> [GroceryItem] {
        do {
            let data = try Data(contentsOf: fileURL)
            return try decode(type: [GroceryItem].self, data)
        } catch let error as NSError {
            print(error.debugDescription)
        }

        return []
    }


    // write JSON to file
    func write(_ item: GroceryItem) {
        do {
            let data = try encode(item)
            try data.write(to: fileURL, options: Data.WritingOptions.atomicWrite)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }

    // encode from GroceryItem to JSON
    private func encode<T>(_ item: T) throws -> Data where T: Encodable {
        return try JSONEncoder().encode(item)
    }

    // decode from JSON to GroceryItem
    private func decode<T>(type: T.Type, _ data: Data) throws -> T where T: Decodable {
        return try JSONDecoder().decode(type, from: data)
    }
}
