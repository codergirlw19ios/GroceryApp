//
//  RecipeSearchTableViewController.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/29/19.
//

import UIKit

class RecipeSearchViewController: UITableViewController {

    let model = RecipeSearchModel(persistence: RecipeSearchPersistence(filename: "RecipeSearch"), recipeNetwork: RecipeNetwork())

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        model.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? QueryViewController {
            destination.delegate = self
        }
    }
}

extension RecipeSearchViewController {

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.numberOfRecipes
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }

        let recipe = model.recipeFor(row: indexPath.row)

        cell.decorateCell(with: recipe)

        return cell
    }
}

extension RecipeSearchViewController: RecipeSearchModelDelegate {
    func dataUpdated() {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

extension RecipeSearchViewController: QueryViewControllerDelegate {
    func update(searchQuery: RecipeSearchQuery) {
        model.update(searchQuery: searchQuery)
    }
}
