//
//  RecipeSearchTableViewController.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 5/24/19.
//

import UIKit

class RecipeSearchTableViewController: UITableViewController, RecipeSearchModelDelegate, QueryViewControllerDelegate {
    let model = RecipeSearchModel(network: RecipeNetwork(), persistence: RecipeSearchPersistence(filename: "recipes"))
    
    var dismissKeyboardGesture: UITapGestureRecognizer?
    
    func dataUpdated() {
        self.tableView.reloadData()
        view.layoutIfNeeded()
    }
    
    //Write a prepare(for:sender:) segue function for
    //destination as QueryViewController and set delegate to self. On the storyboard, /create a push
    //segue from the Search UIBarButtonItem to the QueryViewController.
    func updateSearchQuery(searchQuery: RecipeSearchQuery) {
        model.updateSearchQuery(query: searchQuery)
        model.delegate = self
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getRecipeCount()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeId", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }

        let recipeItem: Recipe? = model.getRecipe(rowNum: indexPath.row)
        cell.decorate(recipe: recipeItem)

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
