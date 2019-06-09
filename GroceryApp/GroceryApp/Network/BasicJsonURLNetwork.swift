//
//  BasicJsonURLNetwork.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 5/3/19.
//

import Foundation

class BasicJsonURLNetwork<T>: URLNetworkProtocol where T: Decodable {
    let baseURL: String
    let mimeType: String

    init(baseURL: String, mimeType: String = "application/json"){
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
