//
//  InformationView.swift
//  Overfloweth
//
//  Created by Shaun Anderson on 29/5/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

class InformationView: UIView {
    var actionNameLabel: UILabel
    var actionDescLabel: UILabel
    //var rankLabel: UILabel
    //var suitImageView: UIImageView
    
    init(frame: CGRect, card: Card) {
        actionNameLabel = UILabel(frame: CGRect(x: frame.width - 175, y: 25, width: 150, height: 40))
        actionDescLabel = UILabel(frame: CGRect(x: 25, y: 150, width: frame.width - 50, height: 100))
        //self.bottomText = UILabel(frame: CGRect(x: frame.width - 75, y: frame.height - 75, width: 50, height: 50))
        //self.bottomSuit = UIImageView(frame: CGRect(x: frame.width - 63.5, y: frame.height - 100, width: 25, height: 25))
        super.init(frame: frame)
        self.actionNameLabel.text = card.actionName
        self.actionNameLabel.textColor = UIColor.white
        self.actionNameLabel.textAlignment = NSTextAlignment.right

        self.actionDescLabel.text = card.actionDescription
        self.actionDescLabel.textColor = UIColor.gray
        self.actionDescLabel.textAlignment = NSTextAlignment.left
        self.actionDescLabel.numberOfLines = 0
        self.actionDescLabel.alpha = 0


        // TODO: set text and size
        self.backgroundColor = UIColor(white: 0, alpha: 0.75)
        
        self.addSubview(actionNameLabel)
        self.addSubview(actionDescLabel)
    }
    
    public func AnimateInUI ()
    {
        actionDescLabel.frame = CGRect(x: 25, y: 50, width: frame.width - 50, height: frame.height-150)
        UIView.animate(withDuration: 1, animations: {
            self.actionDescLabel.alpha = 1
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
