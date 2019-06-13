//
//  RecipeSearchModel.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 5/17/19.
//

import Foundation
import UIKit

protocol RecipeSearchModelDelegate: class {
    func dataUpdated()
}

class RecipeSearchModel {
    let network: RecipeNetwork
    let persistence: RecipeSearchPersistence
    var recipes = [Recipe]() {
        didSet {
            self.delegate?.dataUpdated()
        }
    }
    weak var delegate: RecipeSearchModelDelegate?
    
    
    var recipeSearchQuery: RecipeSearchQuery? {
//        didSet {
//            guard let query = recipeSearchQuery else { return }
//            persistence.writeRecipeSearchQuery(query)
//            //func fetch (completion: @escaping (ResultType?) -> () )
//            // optional Recipe Array is the return Type
//            // func fetch(with query: Query, completion: @escaping ([Recipe]?) -> ()) {
//
//            network.fetch(with: recipeSearchQuery) { optionalRecipeArray in
//                self.recipes = optionalRecipeArray ?? [Recipe]()
//            }
//        }
        
        didSet {
            persistence.write(recipeSearchQuery)
            //func fetch (completion: @escaping (ResultType?) -> () )
            // optional Recipe Array is the return Type
            // func fetch(with query: Query, completion: @escaping ([Recipe]?) -> ()) {
            // The recipeNetwork calls the
            // base class for recipepuppy is a URLNetwork ( fetch )
            // private let network = BasicJsonURLNetork <RecipeSearchResult>(baseURL: "http://recipepuppy.com/api")
            network.fetch(with: recipeSearchQuery as! RecipeSearchQuery){
                optionalRecipeArray in
                self.recipes = optionalRecipeArray ?? [Recipe]()
            }
    }
    }

    init(network: RecipeNetwork, persistence: RecipeSearchPersistence) {
        self.network = network
        self.persistence = persistence
    }
    
    func getRecipeCount() -> Int {
        return recipes.count
    }
    
    func getRecipe(rowNum: Int) -> Recipe? {
        guard rowNum < getRecipeCount() else { return nil }
        return recipes[rowNum]
    }
    
    func updateSearchQuery(query: RecipeSearchQuery) {
        self.recipeSearchQuery = query
    }
}
