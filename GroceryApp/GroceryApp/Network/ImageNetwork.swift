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
    
    init(baseURL: String, mimeType: String =  "image/jpeg")
    {
        self.baseURL = baseURL
        self.mimeType = mimeType
    }
    
    // result is the completion handler for ImageNetwork
    func result(from data: Data) -> UIImage? {
        guard let result = try? UIImage(data: data) else
        {
            return nil
        }
        
        return result
    }
    
    
}
