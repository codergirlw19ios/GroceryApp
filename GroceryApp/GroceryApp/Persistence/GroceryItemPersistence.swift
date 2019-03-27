//
//  ShoppingListPersistence.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 3/14/19.
//

import Foundation

   // make this a generic persistence class by adding a parameter to the persistence for the filename in the init

class GroceryItemPersistence {

    private let fileName = "ShoppingList"
    private let type = "json"

    private let fileURL: URL

    init() {
        fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(fileName, isDirectory: false)
            .appendingPathExtension(type)
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
    func write(_ list: [GroceryItem]) {
        do {
            let data = try encode(list)
            try data.write(to: fileURL, options: .atomicWrite)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }

    // decode from JSON to a Type
    private func decode<T>(type: T.Type, _ data: Data) throws -> T where T: Decodable {
        return try JSONDecoder().decode(type, from: data)
    }

    // encode from a Type to JSON
    private func encode<T>(_ item: T) throws -> Data where T: Encodable {
        return try JSONEncoder().encode(item)
    }
}
