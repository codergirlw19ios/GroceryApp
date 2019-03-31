//
//  GroceryTripViewController.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 3/26/19.
//

import UIKit
class GroceryTripViewController: UIViewController {
    
    
    @IBOutlet weak var groceryTripTable: UITableView!
    
    let model = ShoppingListModel(persistence: ShoppingListPersistence("Cart"))

    override func viewDidLoad() {
        super.viewDidLoad()
        groceryTripTable.dataSource = self
        groceryTripTable.delegate = self
    }
}
    extension GroceryTripViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //handle selecting a row for editing
            
        }
    }
    
extension GroceryTripViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = groceryTripTable.dequeueReusableCell(withIdentifier: "groceryTripCell", for: indexPath)
        let groceryItem: GroceryItem? = model.groceryItemFor(row: indexPath.row)
        //grocery item name
        cell.textLabel?.text = groceryItem?.name
        //quantity
        cell.detailTextLabel?.text = groceryItem?.quantity != nil ? String(groceryItem!.quantity): ""
        return cell
    }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // all items in our shopping list
            return model.listCount
        }
    
    }

