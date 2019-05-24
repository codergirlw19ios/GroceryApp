//
//  QueryViewController.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 5/24/19.
//

import UIKit
protocol QueryViewControllerDelegate:class {
    func updateSearchQuery(searchQuery: RecipeSearchQuery)
}

class QueryViewController: UIViewController {
    
    @IBOutlet weak var queryTableView: UITableView!
    @IBOutlet weak var queryTextField: UITextField!
    
    let model: QueryModel
    var recipeSearchModel : RecipeSearchModel?
    
    weak var delegate: QueryViewControllerDelegate?
    var searchButton: UIBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchNewQuery))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "New Query"
        self.navigationItem.setLeftBarButtonItems([UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewQuery)), UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchNewQuery))], animated: true)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewIngredient))
        searchButton.isEnabled = false
        queryTableView.delegate = self
        queryTableView.dataSource = self
        queryTextField.delegate = self
    }
    @objc func searchNewQuery() {
        
        if ((queryTextField != nil && queryTextField.text != "") || model.getNumberOfIngredients() >= 1) {
            var searchQuery = RecipeSearchQuery(name: queryTextField.text ?? "", ingredients: model.ingredients)
            recipeSearchModel?.updateSearchQuery(query: searchQuery)
            navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    @objc func cancelNewQuery() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addNewIngredient() {
        queryTableView.beginUpdates()
        queryTableView.insertRows(at: [IndexPath(row: model.getNumberOfIngredients(), section:0)], with: .automatic)
        model.addIngredient()
        queryTableView.endUpdates()
    }
}

extension  QueryViewController: QueryViewControllerDelegate {
    func updateSearchQuery(searchQuery: RecipeSearchQuery) {
        recipeSearchModel?.updateSearchQuery(query: searchQuery)
    }
    
    
}

extension QueryViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.row = indexPath.row
        let cell = tableView.cellForRow(at: indexPath) as! QueryTableViewCell
        model.updateIngredient(row: indexPath.row, ingredient: cell.ingredientTextField.text ?? "")
        //Where is this?
        model.selectedRow = nil
        
        //Then use the same validation logic as the save function to
        //determine whether or not to enable the save button.
    }
    
}

extension QueryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getNumberOfIngredients()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = queryTableView.dequeueReusableCell(withIdentifier: "ingredientTableCellId", for: indexPath) as? QueryTableViewCell else {
            return UITableViewCell()
        }
        
        let ingredient: String? = model.getIngredient(row: indexPath.row)
        
        cell.decorateCell(with: ingredient)
        
        return cell
    }
    
}

extension QueryViewController: UITextFieldDelegate {
    //Conform QueryViewController to UITextFieldDelegate. In textFieldDidEndEditing(_:), use the same validation logic as the save function to determine whether or not to enable the save button.
    func textFieldDidEndEditing(_ textField: UITextField) {
        <#code#>
    }
}
