//
//  GroceryTripTableViewCell.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 3/27/19.
//

import UIKit

class GroceryTripTableViewCell: UITableViewCell {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!

    func decorateCell(with groceryItem: GroceryItem?){
        guard let groceryItem = groceryItem else {
            return
        }
        nameLabel.text = groceryItem.name
        quantityLabel.text = String(groceryItem.quantity)
        costLabel.text = Validation.currency(from: groceryItem.cost ?? 0.0)
    }
}
