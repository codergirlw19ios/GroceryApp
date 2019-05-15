//
//  BasicJsonURLNetwork.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 5/6/19.
//

import Foundation

class BasicJsonURLNetwork<T>: URLNetworkProtocol where T:Decodable{
    var baseURL: String = ""
    
    var mimeType: String = "application/json"
    
    func result ( from data: Data) -> T? {
        guard let result = try? JSONDecoder().decode(T.self, from: data) else
        {
            return nil
        }
        return result
    }
    
    init(baseURL: String, mimeType: String?) {
        self.baseURL = baseURL
        self.mimeType = mimeType ?? "application/json"
    }
    
}
