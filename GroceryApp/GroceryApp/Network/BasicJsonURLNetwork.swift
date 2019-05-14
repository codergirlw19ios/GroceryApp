//
//  BasicJsonURLNetwork.swift
//  GroceryApp
//
//  Created by johnekey on 5/6/19.
//

import Foundation
import UIKit



class BasicJsonURLNetork<T>: URLNetworkProtocol where T: Decodable{
    var baseURL: String = ""
    var mimeType: String = "application/json"
    typealias ResultType = T
    
    init(baseURL: String, _ mimeType: String = "application/json")
    {
        self.baseURL = baseURL
        self.mimeType = mimeType
    }
    
    func result(from data: Data) -> T? {
        guard let result = try? JSONDecoder().decode(T.self, from: data) else
        {
            return nil
        }
        
        return result
    }
}
