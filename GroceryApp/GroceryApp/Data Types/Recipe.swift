//
//  Recipe.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/29/19.
//

import Foundation
import UIKit

class Recipe {
    let name: String
    let link: URL
    let imageURL: URL?
    let ingredients: [GroceryItem]

    // we only fetch the image if we look at the recipe in detail
    var image: UIImage?

    init(recipeResult: RecipeResult) {
        self.name = recipeResult.name
        self.link = recipeResult.link
        self.imageURL = recipeResult.imageURL
        self.ingredients = recipeResult.ingredients.components(separatedBy: ",").map {

            // we aren't given a quantity by the api, so initialize the grocery item to 0
            GroceryItem(name: $0, quantity: 0)
        }
    }
}
