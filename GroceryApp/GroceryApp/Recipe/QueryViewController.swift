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
    
    let model = QueryModel(ingredients: [])
    var dismissKeyboardGesture: UITapGestureRecognizer?
    
    weak var delegate: QueryViewControllerDelegate?
    var searchButton: UIBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchNewQuery))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "New Query"
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewIngredient))
        
        navigationItem.setLeftBarButtonItems([UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewQuery)), searchButton], animated: true)
        
        searchButton.isEnabled = false
        queryTableView.delegate = self
        queryTableView.dataSource = self
        queryTextField.delegate = self
    }
    @objc func searchNewQuery() {
        saveCurrent()
        if ((queryTextField != nil && queryTextField.text != "") || model.getNumberOfIngredients() >= 1)
            {
            print(model.ingredients)
            let searchQuery = RecipeSearchQuery(name: queryTextField.text ?? "", ingredients: model.ingredients)
                delegate?.updateSearchQuery(searchQuery: searchQuery)
            navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    @objc func cancelNewQuery() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addNewIngredient() {
        saveCurrent()
        queryTableView.beginUpdates()
//        queryTableView.insertRows(at: [IndexPath(row: model.getNumberOfIngredients(), section:0)], with: .automatic)
        queryTableView.insertRows(at: [IndexPath(row: 0, section:0)], with: .automatic)
        model.addIngredient()
        queryTableView.endUpdates()
    }
    
    func saveCurrent() {
        if model.row != nil {
            let cell = queryTableView.cellForRow(at: IndexPath(row: model.row!, section: 0)) as? QueryTableViewCell
            model.updateIngredient(ingredient: cell?.ingredientTextField.text ?? "")
        }
    }

    
    @objc func endEditing() {
        view.endEditing(true)
    }
}

extension QueryViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.row = indexPath.row
        let cell = tableView.cellForRow(at: indexPath) as? QueryTableViewCell
//        model.updateIngredient(ingredient: cell.ingredientTextField.text ?? "")
        cell?.ingredientTextField.becomeFirstResponder()
//        model.row = nil
        
        //Then use the same validation logic as the save function to
        //determine whether or not to enable the save button.
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if ((queryTextField != nil && queryTextField.text != "") || model.getNumberOfIngredients() >= 1) {
//            searchButton.isEnabled = true
//        }
        let cell = tableView.cellForRow(at: indexPath) as? QueryTableViewCell
        
        model.updateIngredient(ingredient: cell?.ingredientTextField.text ?? "")
        
        if let query = queryTextField.text, !query.isEmpty || model.getNumberOfIngredients() > 0 {
            searchButton.isEnabled = true
        }
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
        model.row = indexPath.row
        let ingredient: String? = model.getIngredient(row: indexPath.row)
        cell.delegate = self
        cell.ingredientTextField.becomeFirstResponder()
        cell.decorate(ingredient: ingredient)
        
        return cell
    }
    
}

extension QueryViewController: UITextFieldDelegate, QueryTableViewCellDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(dismissKeyboardGesture!)
        return true
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if (dismissKeyboardGesture != nil) {
//            view.removeGestureRecognizer(dismissKeyboardGesture!)
//        }
//        textField.resignFirstResponder()
//        return true
//    }
    
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if (textField != queryTextField) {
//            model.updateIngredient(ingredient: textField.text ?? "")
//        }
//        if ((queryTextField != nil && queryTextField.text != "") || model.getNumberOfIngredients() >= 1) {
//            searchButton.isEnabled = true
//        }
//
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let query = queryTextField.text, !query.isEmpty || model.getNumberOfIngredients() > 0 {
            searchButton.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let gesture = dismissKeyboardGesture {
            view.removeGestureRecognizer(gesture)
            dismissKeyboardGesture = nil
        }
        
        if textField != queryTextField {
            model.updateIngredient(ingredient: textField.text ?? "")
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
//        view.addGestureRecognizer(dismissKeyboardGesture!)
//    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if (dismissKeyboardGesture != nil) {
//            view.removeGestureRecognizer(dismissKeyboardGesture!)
//        }
//        textField.resignFirstResponder()
//        return true
//    }
}


