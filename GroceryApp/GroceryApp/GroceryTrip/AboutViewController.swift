//
//  AboutViewController.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 5/1/19.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let randomCatNetwork = RandomCatNetwork()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var catImage: UIImage? = nil
        randomCatNetwork.fetch { image in
            print("AboutViewController fetch", image ?? "nil")
            catImage = image
        }

        DispatchQueue.main.async {
            print("AboutViewController async", catImage ?? "nil")
            if catImage == nil {
                self.imageView.image = #imageLiteral(resourceName: "chateau")
            } else {
                self.imageView.image = catImage
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "About"
    }
}
