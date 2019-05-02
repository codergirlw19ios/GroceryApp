//
//  Network.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 5/1/19.
//

import Foundation

protocol URLDataTaskHandler {
    associatedtype Result
    func result(from data: Data) -> Result?
}

protocol URLTask {
    var baseURL: String { get }
    var mimeType: String { get }
}

protocol URLNetworkProtocol: class {
    associatedtype Task: URLTask

    func fetch(for task: Task, completion: @escaping (Data?) -> ())
    func handleClientError(_ error: Error)
    func handleServerError(_ urlResponse: URLResponse?)
}

struct JSONDataTask<T>: URLTask, URLDataTaskHandler where T: Decodable {
    typealias Result = T

    let baseURL: String
    let mimeType = "application/json"

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func result(from data: Data) -> T? {
        guard let result = try? JSONDecoder().decode(T.self, from: data) else
        {
            return nil
        }

        return result
    }
}

class jsonURLNetwork<T>: URLNetworkProtocol where T: Decodable {

    func handleClientError(_ error: Error) {
        print(#function)
        print(error)
    }

    func handleServerError(_ urlResponse: URLResponse?) {
        print(#function)
        print(urlResponse.debugDescription)
    }

    func fetch(for task: JSONDataTask<T>, completion: @escaping (Data?) ->()) {
        let url = URL(string: task.baseURL)!

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

            if let mimeType = httpResponse.mimeType, mimeType == task.mimeType,
                let data = data {

                completion(data)
                return
            }

            completion(nil)
        }

        task.resume()
    }
}
