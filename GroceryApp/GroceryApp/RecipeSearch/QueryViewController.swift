//
//  QueryViewController.swift
//  GroceryApp
//
//  Created by johnekey on 5/17/19.
//

import UIKit

protocol QueryViewControllerDelegate: class {
    func updateRSModel(searchQuery: RecipeSearchQuery)
}

class QueryViewController: UIViewController {

    @IBOutlet weak var queryTableView: UITableView!
    @IBOutlet weak var queryTextField: UITextField!
    weak var qvcDelegate: QueryViewControllerDelegate?
    var model: QueryModel?
    var recipeSearchModel : RecipeSearchModel?  // passed in via segue
    
//    let searchButton = UIBarButtonItem.init(title: "Search", style: .plain, target: self, action: #selector(searchNewQuery))
//
//    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewQuery))
//
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "New Query"
        
        self.navigationItem.rightBarButtonItem = (UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewIngredient)))
        
       self.navigationItem.setLeftBarButtonItems([UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewQuery)), UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchNewQuery)) ], animated: false)
        
   //     searchButton.isEnabled = true
        queryTableView.dataSource = self
        queryTableView.delegate = self
        queryTextField.delegate = self
        // set the controllers delegate to QueryViewController
        // i.e.  QueryViewController is listening to whatever events the QueryViewController delegate will raise
        // QUESTION  Why not just call the recipeSearchModel.updateRecipeSearchQuery directly instead of using 2 delegates
        qvcDelegate = self
        
    }
    
    @objc func searchNewQuery() {
        // Gather info from the fields and construct the query
        var searchQuery = RecipeSearchQuery(query: "omlet", ingredients: ["eggs","milk"])
        
        // QUESTION  Why not just call the recipeSearchModel.updateRecipeSearchQuery directly instead of using 2 delegates
        // trigger the delegate to update Recipe Search model
   //     qvcDelegate?.updateRSModel(searchQuery: searchQuery)
        
        // is the
        recipeSearchModel?.updateRecipeSearchQuery(query: searchQuery)
        navigationController?.popViewController(animated: true)
    }

    @objc func cancelNewQuery() {
       navigationController?.popViewController(animated: true)
    }
    
    @objc func addNewIngredient() {
        navigationController?.popViewController(animated: true)
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

// Listening for the updateRSModel event/delegate from QVCController
extension QueryViewController: QueryViewControllerDelegate {
    
    func updateRSModel(searchQuery: RecipeSearchQuery) {
        recipeSearchModel?.updateRecipeSearchQuery(query: searchQuery)
    }
        
}

extension QueryViewController : UITableViewDelegate {
    
}

extension QueryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.ingredientCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = queryTableView.dequeueReusableCell(withIdentifier: "IngredientTableCelIID", for: indexPath) as? QueryTableViewCell else {
                return UITableViewCell()
        }
            
        // retrieve the grocery item for this index path
        let ingredient: String? = model?.getIngredient(row: indexPath.row)
        
        cell.decorateCell(with: ingredient)
        
        return cell
    }
    
}

extension QueryViewController: UITextFieldDelegate {
    
}
