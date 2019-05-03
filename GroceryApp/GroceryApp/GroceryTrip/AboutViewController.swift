//
//  AboutViewController.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 5/1/19.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    private let randomCatNetwork = BasicJsonURLNetwork<RandomCatResult>(baseURL: "https://aws.random.cat/meow")

    private struct RandomCatResult: Decodable {
        let file: String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRandomCat()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "About"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "New Cat", style: .plain, target: self, action: #selector(loadRandomCat))
    }

    @objc
    private func loadRandomCat() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.randomCatNetwork.fetch { optionalCatResult in
                switch optionalCatResult {
                case .none:
                    return
                case .some(let result):
                    let imageNetwork = ImageNetwork(baseURL: result.file)
                    imageNetwork.fetch { [weak self] imageResult in
                        switch imageResult {
                        case .none:
                            return
                        case .some(let image):
                            self?.imageView.image = image
                        }
                    }
                }
            }
        }
    }
}
