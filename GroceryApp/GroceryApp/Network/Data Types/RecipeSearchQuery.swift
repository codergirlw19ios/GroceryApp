//
//  RecipeSearchQuery.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/29/19.
//

import Foundation

// Since the data on the api, and thus the results, can change, we actually want to persist the query, not the api. If the app crashes/reopens, we want to rerun the query, not load potentially bad data.
struct RecipeSearchQuery: Query, Codable {
    let query: String

    // comma separated list
    let ingredients: String

    init(query: String, ingredients: [String], page: Int? = nil) {
        self.init(query: query, ingredients: ingredients.joined(separator: ","), page: page)
    }

    init(query: String, ingredients: String, page: Int? = nil) {
        self.query = query
        self.ingredients = ingredients
        self.page = page

    }

    let page: Int?

    var urlString: String {
        var result = "?"
        print(result)

        var needsAnd: Bool = false

        if !ingredients.isEmpty {
            result.append("i=" + ingredients)
            needsAnd = true
            print(result)

        }

        if !query.isEmpty {
            if needsAnd {
                result.append("&")
                print(result)

            }
            result.append("q=" + query)
            needsAnd = true
        }

        if let page = page {
            if needsAnd {
                result.append("&")
                print(result)

            }
            result.append("p=" + String(page))
        }
        print(result)

        return result
    }
}
