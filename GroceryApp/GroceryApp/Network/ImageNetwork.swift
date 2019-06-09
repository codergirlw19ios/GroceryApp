//
//  ImageNetwork.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 5/1/19.
//

import Foundation
import UIKit

class ImageNetwork: URLNetworkProtocol {
    let baseURL: String
    let mimeType: String

    init(baseURL: String, mimeType: String = "image/jpeg") {
        self.baseURL = baseURL
        self.mimeType = mimeType
    }

    func result(from data: Data) -> UIImage? {
        let image = UIImage(data: data)
        return image
    }
}
