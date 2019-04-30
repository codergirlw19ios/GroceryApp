//
//  RecipeSearchQuery.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/29/19.
//

import Foundation

// Since the data on the api, and thus the results, can change, we actually want to persist the query, not the api. If the app crashes/reopens, we want to rerun the query, not load potentially bad data.
struct RecipeSearchQuery: Codable {
    let query: String

    // comma separated list
    let ingredients: [String]

    init(query: String, ingredients: [GroceryItem]) {
        self.init(query: query, ingredients: ingredients.map { $0.name })
    }

    init(query: String, ingredients: [String], page: Int? = nil) {
        self.query = query
        self.ingredients = ingredients
        self.page = page
    }

    let page: Int?

    var urlString: String {
        // build base query with ingredients
        var result = "?i=" + ingredients.joined(separator: ",") + "&q=" + query

        // if a specific page is requested, use it
        if let page = page {
            result.append("&p=" + String(page))
        }

        return result
    }
}
