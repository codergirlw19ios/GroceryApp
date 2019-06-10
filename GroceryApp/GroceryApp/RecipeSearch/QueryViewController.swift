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
    weak var qvcDelegate: QueryViewControllerDelegate?// set to the RecipeSearchViewController
    let model = QueryModel(ingredients: [])

    
    let searchButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchNewQuery))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "New Query"
        
        self.navigationItem.rightBarButtonItem = (UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewIngredient)))
        
       self.navigationItem.setLeftBarButtonItems([UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewQuery)), searchButton  ], animated: false)
        
        queryTableView.dataSource = self
        queryTableView.delegate = self
        queryTextField.delegate = self

        model.delegate = self
        
        searchButton.isEnabled = false
        
    }
    
    @objc func searchNewQuery() {
        
        guard let queryText = try? Validation.notEmpty(queryTextField.text) else {
            return
        }
        
        if (model.ingredientCount < 1 ) {
            return
        }
        
        saveCurrentIngredient()
        
        // Gather info from the fields and construct the query
        // This triggers the fetch
        let searchQuery = RecipeSearchQuery(query: queryText, ingredients: model.ingredients)
        
        // trigger the delegate to update Recipe Search model
        qvcDelegate?.updateRSModel(searchQuery: searchQuery)
        
         navigationController?.popViewController(animated: true)
    }

    @objc func cancelNewQuery() {
       navigationController?.popViewController(animated: true)
    }
    
    @objc func addNewIngredient() {
        
        saveCurrentIngredient()
        queryTableView.beginUpdates()
        queryTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        // add an ingredient so it returns 1 when asked
        model.addIngredient(name: "")
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

    func saveCurrentIngredient() {
    
        if model.row == -1 {
            return
        }
        
        guard let cell = queryTableView.cellForRow(at: IndexPath(row: model.row, section: 0)) as? QueryTableViewCell else {
            return
        }
        
        model.updateIngredient(name: cell.ingredientField.text ?? "")
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
        model.row = indexPath.row
        guard let cell = tableView.cellForRow(at: indexPath) as? QueryTableViewCell else {
            return
        }
        
        model.updateIngredient(name: cell.ingredientField.text!)
        model.row = -1
       
    }
}

extension QueryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.ingredientCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = queryTableView.dequeueReusableCell(withIdentifier: "IngredientTableCellID", for: indexPath) as? QueryTableViewCell else {
                return UITableViewCell()
        }
            
        // retrieve the grocery item for this index path
        let ingredient: String? = model.getIngredient(row: indexPath.row)
        model.row = indexPath.row
        cell.qtvcDelegate = self

        cell.decorateCell(with: ingredient)
        // alternative way for the Controller to handle events from cell...
 //       cell.ingredientField.delegate = self
        
        cell.ingredientField.becomeFirstResponder()
        return cell
    }
    
}

extension QueryViewController: UITextFieldDelegate, QueryTableViewCellDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let query = queryTextField.text, !query.isEmpty || model.ingredientCount > 0 {
            searchButton.isEnabled = true
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField != queryTextField {
            model.updateIngredient(name: textField.text ?? "")
        }
        textField.resignFirstResponder()
        return true
    }
}



