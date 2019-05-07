//
//  FeedbackView.swift
//  GroceryApp
//
//  Created by AGGARWAL, CHETNA [AG/1000] on 4/29/19.
//

import Foundation
import UIKit

class FeedbackView: UIView {
    
    @IBOutlet weak var feedBack: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }
    
    override func awakeFromNib() {
        feedBack.text = ""
        feedBack.backgroundColor = UIColor.white
        feedBack.layer.borderWidth = 1
        feedBack.layer.borderColor = UIColor.darkGray.cgColor
        feedBack.layer.cornerRadius = bounds.width/1.8
    }
    
    func updateFeedBackText(message: String) {
        feedBack.text = message
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
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
