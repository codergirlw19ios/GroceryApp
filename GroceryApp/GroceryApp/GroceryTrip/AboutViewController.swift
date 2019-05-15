//
//  AboutViewController.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 5/8/19.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var catImage: UIImageView!
    private let randomCatNetwork = BasicJsonURLNetwork<RandomCatResult>(baseURL: "https://aws.random.cat/meow", mimeType: "application/json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "About"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Cat", style: .plain, target: self, action: #selector(loadRandomCat))
    }
    @objc func loadRandomCat() {
        self.view.endEditing(true)
        
        
        // Since fetch has an escaping closure
        // A closure is said to escape a function when the closure is passed as an argument to the function, but is called after the function returns.
        
        // Closure expression syntax has the following general form:
        
        // { (parameters) -> return type in
        //     statements
        // }
        //func fetch (completion: @escaping (ResultType?) -> () )
        // optionalCatResult is the return Type
        randomCatNetwork.fetch() { optionalCatResult in
            switch optionalCatResult {
            case .none:
                return
            case .some(let result):
                let imageNetwork = ImageNetwork(baseURL: result.file)
                // Question:  what is going on with fetch no parens and weak self
                imageNetwork.fetch { [weak self] imageResult in
                    switch imageResult {
                    case .none:
                        return
                    case .some(let image):
                        self?.catImage.image = image
                    }
                }
            }
        }
}
}
struct RandomCatResult: Decodable {
    let file: String
}
