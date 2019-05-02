//
//  ImageNetwork.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 5/1/19.
//

import Foundation
import UIKit

class ImageNetwork: URLNetwork {
    init(baseURL: String) {
        super.init(baseURL: baseURL, mimeType: "image/jpeg")
    }

    func result(from data: Data) -> UIImage? {
        let image = UIImage(data: data)
        print("ImageNetwork", image ?? "nil")
        return image
    }
}
