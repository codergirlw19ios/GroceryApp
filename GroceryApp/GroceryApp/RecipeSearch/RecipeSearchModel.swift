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
    private let networking: RecipeSearchNetwork
    private var searchQuery: RecipeSearchQuery? {
        didSet {
            persistence.write(searchQuery!)
            networking.fetch(with: searchQuery!) { optionalRecipes in
                switch optionalRecipes {
                case .none:
                    self.recipes = []
                case .some(let recipes):
                    self.recipes = recipes
                }
            }
        }
    }

    private var recipes: [Recipe] {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.dataUpdated()
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

    init(persistence: RecipeSearchPersistence, networking: RecipeSearchNetwork) {
        self.persistence = persistence
        self.networking = networking

        self.recipes = []
    }

    func update(searchQuery: RecipeSearchQuery) {
        self.searchQuery = searchQuery
    }
}
