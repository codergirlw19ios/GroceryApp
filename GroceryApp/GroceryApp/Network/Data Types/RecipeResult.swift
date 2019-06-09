//
//  SearchResult.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/29/19.
//

import Foundation

// top-level result structure from Recipe Puppy
struct RecipeSearchResult: Decodable {
    let title: String
    let version: Double
    let href: String
    let results: [RecipeResult]
}

// the internal result structure we care about,
// but named in a way we want to use. Order matters.
struct RecipeResult: Decodable {
    let name: String?
    let link: String
    let ingredients: String
    let imageURL: String?

    // once you rename one, you have to declare them all.
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case link = "href"
        case ingredients = "ingredients"
        case imageURL = "thumbnail"
    }
}

