//
//  URLNetwork.swift
//  GroceryApp
//
//  Created by johnekey on 5/6/19.
//

import Foundation
import UIKit

protocol Query {
    func urlString() -> String
}

protocol URLNetworkProtocol: class {
    // type is not specified until protocol is adopted
    associatedtype ResultType
    var baseURL: String { get }
    var mimeType: String { get }
    
    // same as startLoad
    func fetch (with query: RecipeSearchQuery?, completion: @escaping (ResultType?) -> () )
    func handleClientError(_ error: Error)
    func handleServerError(_ urlResponse: URLResponse?)
    func result ( from data: Data) -> ResultType?

}

extension URLNetworkProtocol {
    
    // A closure is said to escape a function when the closure is passed as an argument to the function, but is called after the function returns.
    func fetch(with query: RecipeSearchQuery? = nil, completion: @escaping (ResultType?) ->()) {
        let queryUrlString = query?.urlString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = query != nil ? baseURL + queryUrlString : baseURL
        
        let url = URL(string: urlString)!
//        func fetch(completion: @escaping (ResultType?) ->()) {
//            let url = URL(string: baseURL)!
        // create task in a suspended state -- task is started by Resume call below
        // task delivers the server’s response, data, and possibly errors to a completion handler block
        // Creates a task that retrieves the contents of the specified URL, then calls a handler upon completion.
        
        // Question:  Why don't I have to pass the completion to the dataTask funciton??
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // if error is not nill
            if let error = error {
                self.handleClientError(error)
                return
            }
            
            // if response if valid
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    self.handleServerError(response)
                    return
            }
            
            // if mimeType is the one we asked for
            if let mimeType = httpResponse.mimeType, mimeType == mimeType,
                // if data is not nil
                let data = data {
                // submits work ( completion handler ) to a dispatch queue
                // The completion handler is called on a different Grand Central Dispatch queue than the one that created the task.
                // The Main dispatch queue which is a serial queue - do UI in main thread
                DispatchQueue.main.async {
                    completion(self.result(from: data))
                }
            }
            
        }  // end let task
        
        task.resume()
    }
    
    func handleClientError(_ error: Error) {
        
        print(error)
    }
    
    func handleServerError(_ urlResponse: URLResponse?) {
        print(urlResponse!)
    }
}
