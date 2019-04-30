//
//  QueryTableViewCell.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/30/19.
//

import UIKit

protocol QueryTableViewCellDelegate: class {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    func textFieldDidEndEditing(_ textField: UITextField)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
}

class QueryTableViewCell: UITableViewCell {
    weak var delegate: QueryTableViewCellDelegate?
    @IBOutlet weak var textField: UITextField!

    func decorate(with ingredient: String?) {
        textField.text = ingredient
        textField.delegate = self
    }
}

extension QueryTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldBeginEditing(textField) ?? false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(textField) ?? false
    }
}
