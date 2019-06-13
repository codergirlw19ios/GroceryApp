//
//  RecipeFinder.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 5/15/19.
//

import Foundation
import UIKit

struct RecipeResult: Decodable {
    let name: String?
    let link: String
    let ingredients: String
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
    let ingredients: [GroceryItem]
    
    var image: UIImage?
    
    init(recipeResult: RecipeResult) {
        self.name = recipeResult.name ?? ""
        self.link = recipeResult.link
        self.imageURL = recipeResult.imageURL
        let ingredientsArray =  recipeResult.ingredients.components(separatedBy: ",")
        self.ingredients = ingredientsArray.map { (name) -> GroceryItem in
            return GroceryItem.init(name: name, quantity: 0)
        }
}
}

struct RecipeSearchQuery: Hashable, Codable, Query {
    
    let name: String
    let ingredients: String
    
    //cheese,milk
    init(name: String, ingredients: String) {
        self.name = name
        self.ingredients = ingredients
    }
    
    
    init(name: String, ingredients: [String]) {
        self.init(name: name, ingredients: ingredients.joined(separator: ","))
    }
    
    init(name: String, groceryItems: [GroceryItem]) {
        
        let ingredients = groceryItems.map { (groceryItem) -> String in
            groceryItem.name
        }
        self.init(name: name, ingredients: ingredients)
    }
    
    func urlString() -> String {
        var urlString = "?"
        if(ingredients.count > 0) {
            urlString = urlString + "i=" + ingredients
        }
        return urlString + "&q=" + name
    }
    
}
