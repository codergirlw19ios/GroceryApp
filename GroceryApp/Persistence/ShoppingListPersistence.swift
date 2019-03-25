//
//  ShoppingListPersistence.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 3/25/19.
//

import Foundation

class ShoppingListPersistence {
    //ShoppingList.json
    private let fileName = "ShoppingList"
    private let type = "json"
    
    private let fileURL: URL
    
    init() {
        fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first!
            .appendingPathComponent(fileName, isDirectory: false)
            .appendingPathExtension(type)
    }
    
    //read the data from the file
    func shoppingList() -> [GroceryItem] {
        do {
            let data = try Data(contentsOf: fileURL)
//            return try JSONDecoder().decode([GroceryItem].self, from: data)
            return try decode(type: [GroceryItem].self, data)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    return []
    }
    
    func write(_ list : [GroceryItem]) {
        do {
//            let data = try JSONEncoder().encode(list)
            let data = try encode(list)
            try data.write(to: fileURL, options: .atomicWrite)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    //decode from JSON to a type
    private func decode<T>(type: T.Type, _ data: Data) throws -> T where T: Decodable {
        return try JSONDecoder().decode(type, from: data)
    }
    
    //encode from a Type to JSON
    private func encode<T>(_ item: T) throws -> Data where T: Encodable {
        return try JSONEncoder().encode(item)
    }
    
    
}
