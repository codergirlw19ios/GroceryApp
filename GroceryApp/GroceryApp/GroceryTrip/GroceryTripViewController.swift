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
    @IBOutlet weak var addButton: UIBarButtonItem!

    let stateController = StateController.shared
    var model: GroceryTripModel?
    var modelPersistence = GroceryTripModelPersistence(filename: "GroceryTrip")
    var groceryItemPersistence = GroceryItemPersistence(filename: "Cart")

    private var dismissKeyboardGesture: UITapGestureRecognizer?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groceryTripTableView.reloadData()
        populateTextViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "About", style: .plain, target: self, action: #selector(aboutButtonPressed))

        subTotalTextField.isUserInteractionEnabled = false
        totalTextField.isUserInteractionEnabled = false
        balanceTextField.isUserInteractionEnabled = false
        groceryTripTableView.dataSource = self
        groceryTripTableView.delegate = self
        taxRateTextField.delegate = self
        budgetTextField.delegate = self
        model?.delegate = self

        guard let budget = modelPersistence.data()?.budget else {
            budgetTextField.becomeFirstResponder()
            addButton.isEnabled = false
            return
        }

        model = GroceryTripModel(budget: budget, stateController: stateController, groceryItemPersistence: groceryItemPersistence, groceryTripModelPersistence: modelPersistence)

        populateTextViews()
    }

    @objc func aboutButtonPressed() {
        let aboutViewController = UIStoryboard(name: "GroceryTrip", bundle: nil).instantiateViewController(withIdentifier: "AboutViewController")

        navigationController?.pushViewController(aboutViewController, animated: true)
    }



    func generateModel() {
        guard let budget = try? Validation.validDouble(budgetTextField.text) else {
            return
        }

        model = GroceryTripModel(budget: budget, stateController: stateController, groceryItemPersistence: groceryItemPersistence, groceryTripModelPersistence: modelPersistence)
        model?.delegate = self
        addButton.isEnabled = true

        populateTextViews()
        groceryTripTableView.reloadData()
        view.layoutIfNeeded()
        return
    }


    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
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
        if section == 0 {
            return model?.listCount ?? 0
        } else if section == 1 {
            return 1
        }

        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
        guard let cell = groceryTripTableView.dequeueReusableCell(withIdentifier: "GroceryTripCell", for: indexPath) as? GroceryTripTableViewCell else {
            return UITableViewCell()
        }

        // retrieve the grocery item for this index path
        let groceryItem: GroceryItem? = model?.cartItemFor(row: indexPath.row)

        cell.decorateCell(with: groceryItem)

        return cell
        }
        else if indexPath.section == 1 {
            let cell = groceryTripTableView.dequeueReusableCell(withIdentifier: "demoSection", for: indexPath)
            cell.textLabel?.text = "hello"
            cell.detailTextLabel?.text = "laurie"

            return cell
        }

        return UITableViewCell()

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "grocery items"
        } else if section == 1 {
            return "section title example"
        }

        return nil
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
        let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))

        self.view.addGestureRecognizer(gesture)
        dismissKeyboardGesture = gesture

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
