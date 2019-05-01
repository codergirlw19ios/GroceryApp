//
//  RecipeSearchNetworking.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/29/19.
//

import Foundation

class RecipeSearchNetwork: URLNetwork {
    let baseURL = "http://www.recipepuppy.com/api/"
    let mimeType = "text/javascript"

    func handleClientError(_ error: Error) {
        print(#function)
        print(error)
    }

    func handleServerError(_ urlResponse: URLResponse?) {
        print(#function)
        print(urlResponse.debugDescription)
    }

    func result(from data: Data) -> [Recipe]? {
        guard let searchResult = try? JSONDecoder().decode(RecipeSearchResult.self, from: data) else {
            return nil
        }

        let results = searchResult.results

        return results.map { Recipe(recipeResult: $0) }
    }
}
