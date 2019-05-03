//
//  Network.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 5/1/19.
//

import Foundation


protocol URLNetworkProtocol: class {
    associatedtype ResultType
    var baseURL: String { get }
    var mimeType: String { get }

    func fetch(completion: @escaping (ResultType?) -> ())
    func handleClientError(_ error: Error)
    func handleServerError(_ urlResponse: URLResponse?)
    func result(from data: Data) -> ResultType?
}

extension URLNetworkProtocol {

    func handleClientError(_ error: Error) {
        print(#function)
        print(error)
    }

    func handleServerError(_ urlResponse: URLResponse?) {
        print(#function)
        print(urlResponse.debugDescription)
    }

    func fetch(completion: @escaping (ResultType?) ->()) {
        let url = URL(string: baseURL)!

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
                let data = data {
                DispatchQueue.main.async {
                    completion(self.result(from: data))
                }
            }
        }

        task.resume()
    }
}


