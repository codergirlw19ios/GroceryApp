//
//  BasicJsonURLNetwork.swift
//  GroceryApp
//
//  Created by johnekey on 5/6/19.
//

import Foundation
import UIKit

struct RandomCatResult: Decodable {
    let file: String
}

class BasicJsonURLNetork<T>: URLNetworkProtocol where T: Decodable{
    var baseURL: String = ""
    var mimeType: String = "application/json"
    typealias ResultType = T
    
    init(baseURL: String, mimeType: String? )
    {
        self.baseURL = baseURL
        self.mimeType = mimeType ?? "application/json"
    }
    
    func result(from data: Data) -> T? {
        guard let result = try? JSONDecoder().decode(T.self, from: data) else
        {
            return nil
        }
        
        return result
    }
}
