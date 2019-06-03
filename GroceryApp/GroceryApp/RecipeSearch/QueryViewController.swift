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
        
        model = QueryModel(ingredients: [])
        queryTableView.dataSource = self
        queryTableView.delegate = self
        queryTextField.delegate = self
        // set the controllers delegate to QueryViewController
        // i.e.  QueryViewController is listening to whatever events the QueryViewController delegate will raise
        // QUESTION  Why not just call the recipeSearchModel.updateRecipeSearchQuery directly instead of using 2 delegates
        qvcDelegate = self
        model?.delegate = self
        
    }
    
    @objc func searchNewQuery() {
        
        guard let queryText = try? Validation.notEmpty(queryTextField.text) else {
            return
        }
        
        if (model?.ingredientCount ?? 0 < 1 ) {
            return
        }
        
        // Gather info from the fields and construct the query
        // This triggers the fetch
        var searchQuery = RecipeSearchQuery(query: queryText, ingredients: (model?.ingredients)!)
        
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
        
        queryTableView.beginUpdates()
        queryTableView.insertRows(at: [IndexPath(row: recipeSearchModel?.recipeCount ?? 0, section: 0)], with: .automatic)
        // add an ingredient so it returns 1 when asked
        model?.addIngredient(name: "")
        queryTableView.endUpdates()
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

extension QueryViewController: QueryDelegate {
    func dataUpdated() {
        self.queryTableView.reloadData()
        view.layoutIfNeeded()
    }
    
}

extension QueryViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // handle selecting a row for editing
        model?.row = indexPath.row
        guard let cell = tableView.cellForRow(at: indexPath) as? QueryTableViewCell else {
            return
        }
        
        model?.updateIngredient(name: cell.ingredientField.text!)
       
    }
}

extension QueryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.ingredientCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = queryTableView.dequeueReusableCell(withIdentifier: "IngredientTableCellID", for: indexPath) as? QueryTableViewCell else {
                return UITableViewCell()
        }
            
        // retrieve the grocery item for this index path
        let ingredient: String? = model?.getIngredient(row: indexPath.row)
        model?.row = indexPath.row
        cell.decorateCell(with: ingredient)
        cell.qtvcDelegate = self
        
        return cell
    }
    
}

extension QueryViewController: UITextFieldDelegate, QueryTableViewCellDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == queryTextField {
            view.layoutIfNeeded()
        //    generateModel()
        } else {
            // must be an ingredient
            if !textField.text!.isEmpty {
                model?.updateIngredient(name: textField.text!)
            }
            
        }

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



