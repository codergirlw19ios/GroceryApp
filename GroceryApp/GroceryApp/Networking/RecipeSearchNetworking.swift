//
//  RecipeSearchNetworking.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/29/19.
//

import Foundation

class RecipeSearchNetworking {
    let baseURL = "http://www.recipepuppy.com/api/"

    func fetchRecipes(with query: RecipeSearchQuery, completion: @escaping ([Recipe]) ->()) {
        let url = URL(string: baseURL + query.urlString)!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.handleClientError(error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    self.handleServerError(response)
                    return
            }

            if let mimeType = httpResponse.mimeType, mimeType == "text/javascript",
                let data = data,
                let recipes = self.recipes(from: data) {

                completion(recipes)
            }
        }

        task.resume()
    }

    func handleClientError(_ error: Error) {
        print(#function)
        print(error)
    }

    func handleServerError(_ urlResponse: URLResponse?) {
        print(#function)
        print(urlResponse.debugDescription)
    }

    func recipes(from data: Data) -> [Recipe]? {
        guard let searchResult = try? JSONDecoder().decode(RecipeSearchResult.self, from: data) else {
            return nil
        }

        let results = searchResult.results

        return results.map { Recipe(recipeResult: $0) }
    }
}
