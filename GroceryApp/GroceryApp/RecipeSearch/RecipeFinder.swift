//
//  RecipeFinder.swift
//  GroceryApp
//
//  Created by johnekey on 5/15/19.
//

import Foundation
import UIKit

struct RecipeResult: Decodable {
    let name: String?
    let link: String
    let ingredients: String  // one long comma separated string
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
            case name = "title"
            case link = "href"
            case ingredients = "ingredients"
            case imageURL = "thumbnail"
    }
}

struct RecipeSearchResult: Decodable {
    let title: String
    let version: Double
    let href: String
    let results: [RecipeResult]
}

class Recipe {

    let name: String
    let link: String
    let imageURL: String?
    var ingredients = [GroceryItem]()

    var image: UIImage?

    init(result: RecipeResult)
    {
        self.name = result.name ?? ""
        self.link = result.link
        self.imageURL = result.imageURL

        // Ingredients returned from API is a comma separated list
        let ingredientArray = result.ingredients.components(separatedBy: ",")

        for item in ingredientArray {
            self.ingredients.append(GroceryItem(name: item, quantity: 0))
        }

    }
}


// Codable is a type alias for the Encodable and Decodable protocols. When you use Codable as a type or a generic constraint, it matches any type that conforms to both protocols.
struct RecipeSearchQuery : Codable, Hashable, Query {
    
    let query: String
    // an comma separated list of ingredients
    var ingredients: String
    let page: Int?
    
    // Long string comma separated
    init(query: String, ingredients: String)
    {
        self.query = query
        self.ingredients = ingredients
        self.page = 1
    }
    
    init(query: String, ingredients: [String])
    {
        self.query = query
        self.ingredients = ingredients.joined(separator: ",")
        self.page = 1
    }
    
    init(query: String, groceryItems: [GroceryItem])
    {
        // ingredients is an array of strings
        let ingredients = groceryItems.map { (groceryItem) -> String in groceryItem.name }
        self.init(query: query, ingredients: ingredients)
    }
    
    // ? begins query
    // i begins comma separated list of ingredients
    // q begins the query string
    // p begins the page integer
    // & sparages teh query parameters
    // query = http://recipepuppy.com/api/?i=onions,garic&q=omlet&p=3
    func urlString() -> String {
        var myString = String()
        
        if !ingredients.isEmpty || !query.isEmpty {
            myString = "/?"
            if !ingredients.isEmpty {
                myString += "i="
                myString += ingredients
                if !query.isEmpty {
                    myString += "&"
                }
            }
            if !query.isEmpty {
                myString += "q="
                myString += query
            }
            myString += "&p=1"
        }
        return myString
    }
}
