//
//  RecipeSearchModel.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/29/19.
//

import Foundation

protocol RecipeSearchModelDelegate: class {
    func dataUpdated()
}

class RecipeSearchModel {
    weak var delegate: RecipeSearchModelDelegate?
    private let persistence: RecipeSearchPersistence
    private let recipeNetwork: RecipeNetwork

    private var recipes: [Recipe] {
        didSet {
            self.delegate?.dataUpdated()
        }
    }

    init(persistence: RecipeSearchPersistence, recipeNetwork: RecipeNetwork) {
        self.persistence = persistence
        self.recipeNetwork = recipeNetwork

        self.recipes = []
    }

    private var searchQuery: RecipeSearchQuery? {
        didSet {
            persistence.write(searchQuery!)
            recipeNetwork.fetch(with: searchQuery!) { optionalRecipes in
                switch optionalRecipes {
                case .none:
                    self.recipes = []
                case .some(let recipes):
                    self.recipes = recipes
                }
            }
        }
    }

    var numberOfRecipes: Int {
        return recipes.count
    }

    func recipeFor(row: Int) -> Recipe? {
        guard row < numberOfRecipes else { return nil }
        return recipes[row]
    }

    func update(searchQuery: RecipeSearchQuery) {
        self.searchQuery = searchQuery
    }
}
