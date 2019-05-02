//
//  FeedbackView.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 4/22/19.
//

import UIKit

class FeedbackView: UIView {

    @IBOutlet private weak var message: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()

    }

    override func awakeFromNib() {
        self.message.text = ""
        message.clipsToBounds = true
        message.backgroundColor = UIColor.white
        message.layer.borderWidth = 1
        message.layer.borderColor = UIColor.gray.cgColor
        message.layer.cornerRadius = message.bounds.width/1.8
    }

    private func initSelf() {
        layer.cornerRadius = bounds.width/1.8

        layer.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor

        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1

        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 0
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.gray.cgColor
    }

    func update(message: String){
        self.message.text = message
    }

    func toggleView(isHidden: Bool){
        let opacity: Float = isHidden ? 0.0 : 1.0
        let toggleHidden = CABasicAnimation(keyPath: "opacity")
        toggleHidden.fromValue = layer.opacity
        toggleHidden.toValue = opacity
        toggleHidden.duration = 1
        toggleHidden.repeatCount = 1
        layer.add(toggleHidden, forKey: "opacity")

        layer.opacity = opacity

    }
}

