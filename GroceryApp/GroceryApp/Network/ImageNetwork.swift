//
//  ImageNetwork.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 5/6/19.
//

import Foundation
import UIKit

class ImageNetwork: URLNetworkProtocol {
    typealias ResultType = UIImage
    
    var baseURL: String = ""
    
    var mimeType: String
    
    init(baseURL: String, mimeType: String = "image/jpeg") {
        self.baseURL = baseURL
        self.mimeType = mimeType
    }
    
    func result ( from data: Data) -> UIImage? {
        return UIImage(data: data) 
    }
    
}
