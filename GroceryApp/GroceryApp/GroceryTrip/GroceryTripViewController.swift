//
//  GroceryTripViewController.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 3/27/19.
//

import UIKit

class GroceryTripViewController: UIViewController {

    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var subTotalTextField: UITextField!
    @IBOutlet weak var taxRateTextField: UITextField!
    @IBOutlet weak var totalTextField: UITextField!
    @IBOutlet weak var balanceTextField: UITextField!
    @IBOutlet weak var groceryTripTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var model: GroceryTripModel?
    private var dismissKeyboardGesture: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()

        populateTextViews()

        subTotalTextField.isUserInteractionEnabled = false
        totalTextField.isUserInteractionEnabled = false
        balanceTextField.isUserInteractionEnabled = false
        groceryTripTableView.dataSource = self
        groceryTripTableView.delegate = self
        taxRateTextField.delegate = self
        budgetTextField.delegate = self
        model?.delegate = self

        addButton.isEnabled = false
    }

    func generateModel() {
        guard let budget = try? Validation.validDouble(budgetTextField.text) else {
            return
        }

        model = GroceryTripModel(budget: budget, shoppingList: GroceryItemPersistence(filename: "ShoppingList").groceryItems(), persistence: GroceryItemPersistence(filename: "Cart"))
        addButton.isEnabled = true
        populateTextViews()
        groceryTripTableView.reloadData()
        view.layoutIfNeeded()
        return
    }


    @IBAction func addButtonTapped(_ sender: UIButton) {
        // if there is no model, do not trigger segue; you cannot abort from prepare(for:sender:) so you have to stop the action here.
        guard model != nil else { return }

        performSegue(withIdentifier: "AddItemSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AddToCartViewController else {
            return
        }

        destination.model = model
    }

    func populateTextViews() {
        budgetTextField.text = model?.budgetText
        subTotalTextField.text = model?.subTotalText
        taxRateTextField.text = model?.taxRateText
        totalTextField.text = model?.totalCostText
        balanceTextField.text = model?.balanceText
    }

    deinit {
        print("deinit GroceryTripViewController")
    }
}

extension GroceryTripViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // handle selecting a row for editing
    }
}

extension GroceryTripViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // all items in our shopping list
        return model?.listCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groceryTripTableView.dequeueReusableCell(withIdentifier: "GroceryTripCell", for: indexPath) as? GroceryTripTableViewCell else {
            return UITableViewCell()
        }

        // retrieve the grocery item for this index path
        let groceryItem: GroceryItem? = model?.cartItemFor(row: indexPath.row)

        cell.decorateCell(with: groceryItem)

        return cell
    }
}

extension GroceryTripViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == taxRateTextField, let model = model {
            let taxRate = try? model.validate(cost: taxRateTextField.text)
            try? model.update(taxRate: taxRate ?? 0.00)
            populateTextViews()
            view.layoutIfNeeded()
        } else if textField == budgetTextField {
            if let model = model, let budget = try? Validation.validDouble(budgetTextField.text) {
                model.update(budget: budget)
                populateTextViews()
                view.layoutIfNeeded()
            }
            generateModel()
        }
    }

    @objc func endEditing() {
        self.view.endEditing(true)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))

        if let gesture = dismissKeyboardGesture {
            self.view.addGestureRecognizer(gesture)
        }
        
        return true
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

extension GroceryTripViewController: GroceryTripModelDelegate {
    func dataUpdated() {
        groceryTripTableView.reloadData()
        populateTextViews()
        view.layoutIfNeeded()
    }
}
