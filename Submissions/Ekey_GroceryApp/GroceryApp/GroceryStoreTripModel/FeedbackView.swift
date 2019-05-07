//
//  FeedbackView.swift
//  GroceryApp
//
//  Created by johnekey on 5/7/19.
//

import Foundation
import UIKit

class FeedbackView: UIView {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSelf()
        
    }
    
    override func awakeFromNib() {
        messageLabel.text = ""
        messageLabel.backgroundColor = UIColor.white
        messageLabel.clipsToBounds = true
        
        messageLabel.layer.borderColor = UIColor.darkGray.cgColor
        messageLabel.layer.borderWidth = 1
        messageLabel.layer.cornerRadius = messageLabel.bounds.width/1.8
        
        
    }
    
    func updateLabel( text: String)
    {
        messageLabel.text = text
    }
    
    func initSelf() {
        
        layer.cornerRadius = bounds.width/1.8
        layer.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 0
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.gray.cgColor
        
        
    }

}
