//
//  GroceryTripListViewController.swift
//  GroceryApp
//
//  Created by johnekey on 3/31/19.
//

import UIKit

class GroceryStoreTripListViewController: UIViewController {

  //  let shopperModel = Shopper(persistence: GroceryListPersistence())
    
    
    let gstModel = GroceryStoreTrip(persistence: GroceryListPersistence(),
                                    budget: 100.00,
                                    groceryList: [ GroceryItem( "Milk", 1, 2.50),                                                                                   GroceryItem( "Yogurt",  1,  2.50),                                                                                                                 GroceryItem( "Apples",  4),                                                                                                                ], taxRate: 0.10)
    
    @IBOutlet weak var groceryStoreTripTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groceryStoreTripTableView.dataSource = self
        groceryStoreTripTableView.delegate = self
        
        // let the GroceryListViewController listen for the model's delegate
        gstModel.delegate = self

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension GroceryStoreTripListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // hanlde selecting a row for editing
    }
}

// When the user scrolls off the screen the cell gets dequeued to conserve memory
extension GroceryStoreTripListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gstModel.myCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = groceryStoreTripTableView.dequeueReusableCell(withIdentifier: "groceryStoreTripCellID", for: indexPath)
        
        // var groceryItem: GroceryItem?
        
        do {
            let groceryItem = try gstModel.getGroceryCartItem(index: indexPath.row)
            // item quantity
            cell.detailTextLabel?.text = String(groceryItem!.quantity)
            // item name
            cell.textLabel?.text  = groceryItem?.name
            
        } catch {
            
        }
        
        return cell
    }
    
    
}

extension GroceryStoreTripListViewController : GroceryStoreTripDelegate {
    func dataUpdated() {
        groceryStoreTripTableView.reloadData()
        // or if you just need to do a section -- uses an animation which is prettier...
        // groceryListTableView.reloadSections(<#T##sections: IndexSet##IndexSet#>, with: <#T##UITableView.RowAnimation#>)
    }
}
