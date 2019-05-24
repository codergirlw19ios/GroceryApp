//
//  RecipeSearchViewController.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 5/20/19.
//

import Foundation
import UIKit

class RecipeSearchViewController1: UITableViewController, RecipeSearchModelDelegate {
    let model = RecipeSearchModel(network: RecipeNetwork(), persistence: RecipeSearchPersistence(filename: "recipes"))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        model.delegate = self
        }
    
    func dataUpdated() {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getRecipeCount()
    }
    
    //
}
