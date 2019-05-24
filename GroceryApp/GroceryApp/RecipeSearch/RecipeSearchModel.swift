//
//  RecipeSearchModel.swift
//  GroceryApp
//
//  Created by johnekey on 5/16/19.
//

import Foundation
import UIKit

protocol RecipeSearchModelDelegate: class {
    func dataUpdated()
}

// This class is used populated and used
class RecipeSearchModel {
    
    weak var delegate: RecipeSearchModelDelegate?
    let recipeNetwork: RecipeNetwork
    let recipeSearchPersistence: RecipeSearchPersistence
    // data for the table
    var recipes = [Recipe]() {
        didSet {
            // notify whoever is listening that we added data to this object
            self.delegate?.dataUpdated()
        }
    }
    
    var recipeCount : Int { return recipes.count }
    
    var recipeSearchQuery: RecipeSearchQuery? {
        didSet {
            recipeSearchPersistence.write(recipeSearchQuery)
            //func fetch (completion: @escaping (ResultType?) -> () )
            // optional Recipe Array is the return Type
            // func fetch(with query: Query, completion: @escaping ([Recipe]?) -> ()) {

            // The recipeNetwork calls the
            // base class for recipepuppy is a URLNetwork ( fetch )
            // private let network = BasicJsonURLNetork <RecipeSearchResult>(baseURL: "http://recipepuppy.com/api")

            recipeNetwork.fetch(with: recipeSearchQuery as! RecipeSearchQuery){
                optionalRecipeArray in
                self.recipes = optionalRecipeArray ?? [Recipe]()
                
                let string = "help"
            }
        }
    }
    
    
    
    init(recipeNetwork: RecipeNetwork, persistence: RecipeSearchPersistence){
        self.recipeNetwork = recipeNetwork
        self.recipeSearchPersistence = persistence
    }
    
    func getRecipe(row: Int ) -> Recipe? {
        guard row < recipeCount else { return nil }
        return recipes[row]
        
    }
    
    func updateRecipeSearchQuery(query: RecipeSearchQuery) {
        self.recipeSearchQuery = query
    }
}
