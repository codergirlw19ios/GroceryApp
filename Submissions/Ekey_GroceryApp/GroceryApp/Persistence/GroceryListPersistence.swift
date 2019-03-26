//
//  GroceryListPersistence.swift
//  GroceryApp
//
//  Created by johnekey on 3/25/19.
//

import Foundation

class GroceryListPersistence {
    private let filename = "GroceryList"
    private let type = "json"
    
    private let fileURL: URL
    
    init() {
        
        
        // FileManager default is a singleton
        // ask Amanda questions about standards for saving data..
        //FileManager.SearchpathDirectory is a enum... so I can use the .notation
        // returns an array of URL's [URL]
        fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first!
        .appendingPathComponent(filename, isDirectory: false)
        .appendingPathExtension(type)
        
    }
    
    func readGroceryList() -> [GroceryItem] {
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([GroceryItem].self, from: data)
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
        return []
    }
    
    func writeGroceryList(_ list: [GroceryItem]) {
        do {
            let data = try JSONEncoder().encode(list)
            try data.write(to: fileURL, options: .atomicWrite)
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
    }
}
