//
//  AboutViewController.swift
//  GroceryApp
//
//  Created by johnekey on 5/7/19.
//

import UIKit

struct RandomCatResult: Decodable {
    let file: String
}

class AboutViewController: UIViewController {

    @IBOutlet weak var randomCatImage: UIImageView!
    
    // base class for randomCatNetwork is a URLNetwork ( fetch )
    private let randomCatNetwork = BasicJsonURLNetork <RandomCatResult>(baseURL: "https://aws.random.cat/meow")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title =  "About"
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
                //
                imageNetwork.fetch() { [weak self] imageResult in
                switch imageResult {
                case .none:
                    return
                case .some(let image):
                    self?.randomCatImage.image = image
                }
            }
          }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
