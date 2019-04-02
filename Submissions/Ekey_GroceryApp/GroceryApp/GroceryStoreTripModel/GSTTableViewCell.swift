//
//  GSTTableViewCell.swift
//  GroceryApp
//
//  Created by johnekey on 4/1/19.
//

import UIKit

class GSTTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UILabel!
    
    @IBOutlet weak var ttlCostTextField: UILabel!
    @IBOutlet weak var costTextField: UILabel!
    @IBOutlet weak var qtyTextField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
