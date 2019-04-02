//
//  GroceryTripViewController.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 3/26/19.
//

import UIKit

class GroceryTripViewController: UIViewController {
    let model =
        GroceryTrip(persistence: ShoppingListPersistence("Cart"), budget: 100.0, taxRate: 5.5, shoppingListArray: [GroceryItem(name:"chocolate", quantity: 2, cost: 5.0), GroceryItem(name:"coconut", quantity: 3, cost: 1.0), GroceryItem(name:"bread", quantity: 1, cost: 2.50)])
    
    @IBAction func userTappedAdd(_ sender: UIButton) {
        //call the AddItemSegue
        performSegue(withIdentifier: "AddItemSegueId", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AddGroceryItemViewController else {return}
        destination.model = model
    }
    
    @IBOutlet weak var groceryTripTable: UITableView!
    
    @IBOutlet weak var total: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groceryTripTable.dataSource = self
        groceryTripTable.delegate = self
        total.text = String(model.totalCost)
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
            return model.getCartCount()
        }
    
    }

