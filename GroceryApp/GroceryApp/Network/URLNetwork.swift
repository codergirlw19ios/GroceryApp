import UIKit
import Foundation

protocol Query {
    func urlString() -> String
}

protocol URLNetworkProtocol: class {
    // type is not specified until protocol is adopted
    associatedtype ResultType
    var baseURL: String { get }
    var mimeType: String { get }
    
    // same as startLoad
    func fetch (with query: Query?, completion: @escaping (ResultType?) -> () )
    func handleClientError(_ error: Error)
    func handleServerError(_ urlResponse: URLResponse?)
    func result ( from data: Data) -> ResultType?
    
}

extension URLNetworkProtocol {
    
    func fetch(with query: Query? = nil, completion: @escaping (ResultType?) ->()) {
        let queryUrlString = query?.urlString().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlString = query != nil ? baseURL + queryUrlString : baseURL
        let url = URL(string: urlString)!
        
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
            
        }  // end let task
        
        task.resume()
    }
    
    func handleClientError(_ error: Error) {
        print(error)
    }
    
    func handleServerError(_ urlResponse: URLResponse?) {
        print(urlResponse?.description ?? "nil")
    }
    
    
}
