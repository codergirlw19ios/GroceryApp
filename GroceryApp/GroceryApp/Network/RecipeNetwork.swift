//
//  RecipeSearchNetwork.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/29/19.
//

import Foundation

class RecipeNetwork: URLNetworkProtocol {
    typealias ResultType = Recipe

    let baseURL = "http://www.recipepuppy.com/api/"
    let mimeType = "text/javascript"
    let network: BasicJsonURLNetwork<RecipeSearchResult>

    init() {
        network = BasicJsonURLNetwork<RecipeSearchResult>(baseURL: baseURL, mimeType: mimeType)
    }

    func fetch(with query: Query, completion: @escaping ([Recipe]?) -> ()) {
        network.fetch(with: query) { [weak self] optionalRecipeSearchResult in
            completion(self?.result(from: optionalRecipeSearchResult))
        }
    }

    func result(from searchResult: RecipeSearchResult?) -> [Recipe]? {
        guard let results = searchResult?.results else {
            return nil
        }

        return results.map { Recipe(recipeResult: $0) }
    }

    // no-op
    func result(from data: Data) -> Recipe? {
        return nil
    }
}
