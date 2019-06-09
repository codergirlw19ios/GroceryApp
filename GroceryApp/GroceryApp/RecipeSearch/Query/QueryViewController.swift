//
//  QueryViewController.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/30/19.
//

import UIKit
 
protocol QueryViewControllerDelegate: class {
    func update(searchQuery: RecipeSearchQuery)
}

class QueryViewController: UIViewController {
    @IBOutlet weak var queryTextField: UITextField!
    @IBOutlet weak var ingredientsTableView: UITableView!

    let model = QueryModel()
    weak var delegate: QueryViewControllerDelegate?
    private var dismissKeyboardGesture: UITapGestureRecognizer?
    var saveButton = UIBarButtonItem.init(title: "Search", style: .done, target: self, action: #selector(saveNewQuery))

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "New Query"
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewQuery)),
            saveButton
        ]

        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addNewIngredient))

        saveButton.isEnabled = false

        queryTextField.delegate = self
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
    }

    @objc
    func cancelNewQuery() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    func saveNewQuery() {
        saveCurrent()
        // only allow a search if there is at least a query or an ingredient for the search
        if let query = queryTextField.text, !query.isEmpty || model.ingredientCount > 0 {
            print(model.ingredients)
            delegate?.update(searchQuery: RecipeSearchQuery(query: query, ingredients: model.ingredients, page: nil))
        }

        navigationController?.popViewController(animated: true)
    }

    @objc
    func addNewIngredient() {
        saveCurrent()

        ingredientsTableView.beginUpdates()
        ingredientsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        model.addIngredient()
        ingredientsTableView.endUpdates()
    }

    func saveCurrent() {
        if model.selectedRow != nil {
            let cell = ingredientsTableView.cellForRow(at: IndexPath(row: model.selectedRow!, section: 0)) as? QueryTableViewCell
            model.updateSelectedRow(cell?.textField.text ?? "")
        }
    }
}

extension QueryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.ingredientCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QueryCell", for: indexPath) as? QueryTableViewCell else {
            return UITableViewCell()
        }
        model.selectedRow = indexPath.row

        let ingredient = model.ingredientFor(row: indexPath.row)
        cell.delegate = self
        cell.textField.becomeFirstResponder()

        cell.decorate(with: ingredient)

        return cell
    }
}

extension QueryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.selectedRow = indexPath.row

        let cell = ingredientsTableView.cellForRow(at: indexPath) as? QueryTableViewCell
        cell?.textField.becomeFirstResponder()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = ingredientsTableView.cellForRow(at: indexPath) as? QueryTableViewCell

        model.updateSelectedRow(cell?.textField.text ?? "")

        if let query = queryTextField.text, !query.isEmpty || model.ingredientCount > 0 {
            saveButton.isEnabled = true
        }
    }
}

extension QueryViewController: UITextFieldDelegate, QueryTableViewCellDelegate {

    @objc func endEditing() {
        view.endEditing(true)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))

        view.addGestureRecognizer(gesture)
        dismissKeyboardGesture = gesture

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let query = queryTextField.text, !query.isEmpty || model.ingredientCount > 0 {
            saveButton.isEnabled = true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let gesture = dismissKeyboardGesture {
            view.removeGestureRecognizer(gesture)
            dismissKeyboardGesture = nil
        }

        if textField != queryTextField {
            model.updateSelectedRow(textField.text ?? "")
        }
        
        textField.resignFirstResponder()
        return true
    }
}
