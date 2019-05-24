//
//  RecipeNetwork.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 5/16/19.
//

import Foundation
import UIKit

class RecipeNetwork: URLNetworkProtocol {
    var mimeType: String = "application/json"
    let baseURL: String = "http://www.recipepuppy.com/api/"
//    private let network = BasicJsonURLNetork <RecipeSearchResult>(baseURL: "http://recipepuppy.com/api")
    let network: BasicJsonURLNetwork<RecipeSearchResult>
    
    init() {
        self.network = BasicJsonURLNetwork.init(baseURL: baseURL, mimeType: mimeType)
    }
    
    func result(from data: Data) -> [Recipe]? {
        return nil
    }
    
    func result(from searchResult: RecipeSearchResult?) -> [Recipe]? {
        guard let results = searchResult?.results else {
            return nil
        }
        return results.map{ Recipe(recipeResult: $0)}
    }
    
    //function - {} is the completion. Called the trailing closure
    //escaping tells us that the closure can be called when the class reference is gone. Since the
    // reference is gone, it can crash. weak self means it makes it optional. 
    func fetch(with query: Query?, completion: @escaping ([Recipe]?) -> ()) {
        network.fetch(with: query) { [weak self] optionalRecipeSearchResult in
            completion(self?.result(from: optionalRecipeSearchResult))
        }
    }
    
}
