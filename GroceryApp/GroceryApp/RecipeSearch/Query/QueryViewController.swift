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

    var saveButton = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveNewQuery))

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

        // only allow a search if there is at least a query or an ingredient for the search
        if let query = queryTextField.text, !query.isEmpty || model.ingredientCount > 0 {
            delegate?.update(searchQuery: RecipeSearchQuery(query: query, ingredients: model.ingredients, page: nil))
        }

        navigationController?.popViewController(animated: true)
    }

    @objc
    func addNewIngredient() {
        ingredientsTableView.beginUpdates()
        ingredientsTableView.insertRows(at: [IndexPath(row: model.ingredientCount, section: 0)], with: .automatic)
        model.addIngredient()
        ingredientsTableView.endUpdates()
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
        model.selectedRow = nil

        if let query = queryTextField.text, !query.isEmpty || model.ingredientCount > 0 {
            saveButton.isEnabled = true
        }
    }
}

extension QueryViewController: UITextFieldDelegate, QueryTableViewCellDelegate {

    @objc func endEditing() {
        self.view.endEditing(true)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))

        self.view.addGestureRecognizer(gesture)
        dismissKeyboardGesture = gesture

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != queryTextField {
            model.updateSelectedRow(textField.text ?? "")
            model.selectedRow = nil
        }
        if let query = queryTextField.text, !query.isEmpty || model.ingredientCount > 0 {
            saveButton.isEnabled = true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let gesture = dismissKeyboardGesture {
            self.view.removeGestureRecognizer(gesture)
            dismissKeyboardGesture = nil
        }
        textField.resignFirstResponder()
        return true
    }
}
