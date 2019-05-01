//
//  URLNetwork.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 5/1/19.
//

import Foundation

protocol URLNetwork: class {
    associatedtype ResultType

    var baseURL: String { get }
    var mimeType: String { get }

    func fetch(with query: Query, completion: @escaping (ResultType) -> ())
    func handleClientError(_ error: Error)
    func handleServerError(_ urlResponse: URLResponse?)
    func result(from: Data) -> ResultType?
}

extension URLNetwork {
    func fetch(with query: Query, completion: @escaping (ResultType) ->()) {
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

            if let mimeType = httpResponse.mimeType, mimeType == mimeType,
                let data = data,
                let result = self.result(from: data) {

                completion(result)
            }
        }

        task.resume()
    }
}
