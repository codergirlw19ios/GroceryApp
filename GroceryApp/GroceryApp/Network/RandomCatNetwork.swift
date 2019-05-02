//
//  RandomCatNetwork.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 5/1/19.
//

import Foundation
import UIKit

struct RandomCatResult: Codable {
    let file: String
}

final class RandomCatNetwork: URLNetworkProtocol {
    init() {
        super.init(baseURL: "https://aws.random.cat/meow", mimeType: "application/json")
    }
    func result(from data: Data) -> UIImage? {
        guard let randomCatResult = try? JSONDecoder().decode(RandomCatResult.self, from: data) else {
            return nil
        }

        let imageNetwork = ImageNetwork(baseURL: randomCatResult.file)

        var imageNetworkResult: UIImage? = nil

        imageNetwork.fetch { image in
            print("RandomCatNetwork", image ?? "nil")
            imageNetworkResult = image
        }


        print("imageNetworkResult", imageNetworkResult ?? "nil")
        return imageNetworkResult
    }
}
