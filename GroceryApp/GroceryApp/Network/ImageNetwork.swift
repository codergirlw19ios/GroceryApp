//
//  ImageNetwork.swift
//  GroceryApp
//
//  Created by johnekey on 5/6/19.
//

import Foundation
import UIKit


class ImageNetwork: URLNetworkProtocol {
    
    typealias ResultType = UIImage
    var baseURL: String = ""
    var mimeType: String = "image/jpeg"
    
    init(baseURL: String, mimeType: String? )
    {
        self.baseURL = baseURL
        self.mimeType = mimeType ?? "image/jpeg"
    }
    
    func result(from data: Data) -> UIImage? {
        guard let result = try? UIImage(data: data) else
        {
            return nil
        }
        
        return result
    }
    
    
}
