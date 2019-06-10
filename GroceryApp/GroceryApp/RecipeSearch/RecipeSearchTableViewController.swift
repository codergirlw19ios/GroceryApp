//
//  RecipeSearchTableViewController.swift
//  GroceryApp
//
//  Created by johnekey on 5/16/19.
//

import UIKit

class RecipeSearchTableViewController: UITableViewController {

    var recipeSearchModel : RecipeSearchModel?
    var modelPersistence = RecipeSearchPersistence(filename: "RecipeQuery")
    var recipeNetwork = RecipeNetwork()
    private var dismissKeyboardGesture: UITapGestureRecognizer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeSearchModel = RecipeSearchModel(recipeNetwork: recipeNetwork, persistence: modelPersistence)
        // set the models delegate to RecipeSearchTableViewController
        // i.e.  RecipeSearchTableViewController is listening to whatever events the model delegate will raise
        recipeSearchModel?.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? QueryViewController else {
            return
        }
        destination.qvcDelegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recipeSearchModel != nil {
            return recipeSearchModel?.recipeCount ?? 0
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCellID", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        // retrieve the grocery item for this index path
        let recipeItem: Recipe? = recipeSearchModel?.getRecipe(row: indexPath.row)

        cell.decorateCell(with: recipeItem)
        
        return cell
    }
    

    
    

}
// This class will listen for any events from RecipeSearchModelDelegate
extension RecipeSearchTableViewController: RecipeSearchModelDelegate {
    func dataUpdated() {
        self.tableView.reloadData()
        view.layoutIfNeeded()
    }
}

// Listening for the updateRSModel event/delegate from QVCController
extension RecipeSearchTableViewController: QueryViewControllerDelegate {

    //
    func updateRSModel(searchQuery: RecipeSearchQuery) {
        recipeSearchModel?.updateRecipeSearchQuery(query: searchQuery)
    }
}

extension RecipeSearchTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
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

