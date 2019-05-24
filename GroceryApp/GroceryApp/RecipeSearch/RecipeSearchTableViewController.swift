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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? QueryViewController else {
            return
        }
        
        destination.recipeSearchModel = recipeSearchModel
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    

}
// This class will listen for any events from RecipeSearchModelDelegate
extension RecipeSearchTableViewController: RecipeSearchModelDelegate {
    func dataUpdated() {
        self.tableView.reloadData()
        view.layoutIfNeeded()
    }
}

//// Listening for the updateRSModel event/delegate from QVCController
//extension RecipeSearchTableViewController: QueryViewControllerDelegate {
//
//    //
//    func updateRSModel(searchQuery: RecipeSearchQuery) {
//        recipeSearchModel?.updateRecipeSearchQuery(query: searchQuery)
//    }
//}
