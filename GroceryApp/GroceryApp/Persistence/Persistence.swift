//
//  Persistence.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/2/19.
//

import Foundation

class Persistence {
    internal let filename: String
    internal let type = "json"

    internal let fileURL: URL

    init(filename: String) {
        self.filename = filename
        fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(filename, isDirectory: false)
            .appendingPathExtension(type)
    }

    // read single item JSON from file
    func read<T>() -> T? where T: Decodable {
        do {
            let data = try Data(contentsOf: fileURL)
            return try decode(type: T.self, data)
        } catch let error as NSError {
            print(error.debugDescription)
        }

        return nil
    }

    // read array JSON from file
    func read<T>() -> [T] where T: Decodable {
        do {
            let data = try Data(contentsOf: fileURL)
            return try decode(type: [T].self, data)
        } catch let error as NSError {
            print(error.debugDescription)
        }

        return []
    }

    // write single item JSON to file
    func write<T>(_ item: T) where T: Encodable {
        do {
            let data = try encode(item)
            try data.write(to: fileURL, options: .atomicWrite)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }

    // write array JSON to file
    func write<T>(_ items: [T]) where T: Encodable {
        do {
            let data = try encode(items)
            try data.write(to: fileURL, options: .atomicWrite)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    // decode from JSON to a Type
    internal func decode<T>(type: T.Type, _ data: Data) throws -> T where T: Decodable {
        return try JSONDecoder().decode(type, from: data)
    }

    // encode from a Type to JSON
    internal func encode<T>(_ item: T) throws -> Data where T: Encodable {
        return try JSONEncoder().encode(item)
    }
}
