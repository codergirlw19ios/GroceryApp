//
//  GroceryListViewController.swift
//  GroceryApp
//
//  Created by johnekey on 3/25/19.
//

import UIKit

class GroceryListViewController: UIViewController {

    let model = Shopper()
    
    @IBOutlet weak var groceryListTableView: UITableView!
    
    @IBAction func AddButtonTapped(_ sender: UIBarButtonItem) {
        
        // call the segue - AddItemSegueID
        performSegue(withIdentifier: "AddItemSegueID", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AddGroceryItemViewController else {
            return
        }
        // pass the REAL unique ptr to the model to the destination view controller -
        destination.model = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groceryListTableView.dataSource = self
        groceryListTableView.delegate = self
        
        // let the GroceryListViewController listen for the model's delegate
        model.delegate = self
    }
    // each time a tab bar button is pressed and a view is recalled to the screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groceryListTableView.reloadData()
        
    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GroceryListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // hanlde selecting a row for editing
    }
}

// When the user scrolls off the screen the cell gets dequeued to conserve memory
extension GroceryListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StateController.shared.myGroceryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = groceryListTableView.dequeueReusableCell(withIdentifier: "groceryListCellID", for: indexPath)
        
       // var groceryItem: GroceryItem?
        
        do {
            let groceryItem = try model.getGroceryItem(index: indexPath.row)
            // item quantity
            cell.detailTextLabel?.text = String(groceryItem!.quantity)
            // item name
            cell.textLabel?.text  = groceryItem?.name
            
        } catch {
            
        }
        
        return cell
    }
    
    
}

extension GroceryListViewController : ShopperDelegate {
    func dataUpdated() {
        groceryListTableView.reloadData()
        // or if you just need to do a section -- uses an animation which is prettier...
       // groceryListTableView.reloadSections(<#T##sections: IndexSet##IndexSet#>, with: <#T##UITableView.RowAnimation#>)
    }
    
    
}
