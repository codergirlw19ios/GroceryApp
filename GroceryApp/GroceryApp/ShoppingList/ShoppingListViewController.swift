//
//  ShoppingListViewController.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 3/12/19.
//

import UIKit

class ShoppingListViewController: UIViewController {

    let model = ShoppingListModel(persistence: ShoppingListPersistence())

    @IBOutlet weak var shoppingListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        shoppingListTableView.dataSource = self
        shoppingListTableView.delegate = self

        model.delegate = self
    }


    @IBAction func addButtonTapped(_ sender: UIButton) {
        // call the segue AddItemSegue
        performSegue(withIdentifier: "AddItemSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AddItemViewController else {
            return
        }

        destination.model = model
    }

    deinit {
        print("deinit ShoppingListViewController")
    }
}

extension ShoppingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // handle selecting a row for editing
    }
}

extension ShoppingListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // all items in our shopping list
        return model.listCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = shoppingListTableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath)

        // retrieve the grocery item for this index path
        let groceryItem: GroceryItem? = model.groceryItemFor(row: indexPath.row)

        // title = grocery item name
        cell.textLabel?.text = groceryItem?.name

        // right detail = grocery item quantity
        cell.detailTextLabel?.text = groceryItem?.quantity != nil ? String(groceryItem!.quantity) : ""

        return cell
    }
}

extension ShoppingListViewController: ShoppingListModelDelegate {
    func dataUpdated() {
        shoppingListTableView.reloadData()
    }
}
