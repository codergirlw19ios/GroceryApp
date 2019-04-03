//
//  ShoppingListPersistence.swift
//  GroceryApp
//
//  Created by Sandra Laguerta on 4/3/19.
//

import Foundation

class ShoppingListPersistence {
    //most local, hard-coded and type, save as json
    //ShoppingLIst.json
    
    private let fileName = "ShoppingList"
    private let type = "json"
    
    //class build a file url
    private let fileURL: URL
    
    //build ile url whenever we initializer the persistence class
    //ios class has a file manager
    init() {
        //there is only one fileManager
        //static method on the class that returns a single instance
        //get the url for where documents are stored; arbitrary non-intuitive path so filelamanger will generate
        //userdomanmask is the user's home directory
        //retrieve first url from directory and then retrieve the shoppinglist.json
        //append a path component
        fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(fileName, isDirectory:false)
            .appendingPathExtension(type)
        
    }
    
    //read the data from the file
    //this is something that can fail so throw an error
    func shoppingList() -> [GroceryItem] {
        do {
            //json file contains human readable text, and to make it a struct, have it return a data type; have it decode and initialize from the contents url so if file doesnt exists, throws an error and if it succeeds, use a json decoder
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([GroceryItem].self, from: data)
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
        //if it fails, return an empty array
        return []
        
    }
    
    //write out list to the file
    //downside of flatfile persistence is that we can't just update one grocery item or read one grocery item, we have to write all of it and read all of it at the time; a lot of data will have performance costs so we would need to condider other persistence solutions
    //to write, instead of decode from a gorcery item we need to encode from a grocery item into data
    
    func write (_ list: [GroceryItem]) {
        do {
            let data = try JSONEncoder().encode(list)
            //atomicwrite prevents writing conflicts
            try data.write(to: fileURL, options: .atomicWrite)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }

}
