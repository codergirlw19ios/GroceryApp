//
//  RecipeNetwork.swift
//  GroceryApp
//
//  Created by johnekey on 5/15/19.
//

import Foundation
import UIKit


class RecipeNetwork: URLNetworkProtocol {
    typealias ResultType = String
    var baseURL: String = "http://www.recipepuppy.com/api"
    var mimeType: String

    // base class for recipepuppy is a URLNetwork ( fetch )
    private let network: BasicJsonURLNetork <RecipeSearchResult>

    init()
    {
        self.network = BasicJsonURLNetork <RecipeSearchResult>(baseURL: baseURL)
        self.mimeType = "application/json"
    }

    // interface / protocol version
    func result(from data: Data) -> String? {
        return nil
    }
    
    // overwritten version
    func result(from searchResult: RecipeSearchResult?) -> [Recipe]? {
        // results is an array of [RecipeResult]
        guard let results = searchResult?.results else {
            return nil
        }
        // for each recipeResult -- instantiate a Recipe Object using result
        return results.map { Recipe(result: $0)}
    }
    // ? begins query
    // i begins comma separated list of ingredients
    // q begins the query string
    // p begins the page integer
    // & sparages teh query parameters
    // query = http://recipepuppy.com/api/?i=onions,garic&q=omlet&p=3
    //  The baseURL is appended in the URLNetwork fetch function
    func fetch(with query: RecipeSearchQuery, completion: @escaping ([Recipe]?) -> ()) {
        network.fetch(with: query) { [weak self] optionalRecipeSearchResult in completion(self?.result(from: optionalRecipeSearchResult))
        }
    }
}
