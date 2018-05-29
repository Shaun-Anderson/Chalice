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
    var rankLabel: UILabel
    var suitImageView: UIImageView
    
    init(frame: CGRect, card: Card) {
        actionNameLabel = UILabel(frame: CGRect(x: frame.width - 175, y: 25, width: 150, height: 25))
        actionDescLabel = UILabel(frame: CGRect(x: 25, y: 150, width: frame.width - 50, height: 100))
        rankLabel = UILabel(frame: CGRect(x: 25, y: 25, width: 25, height: 25))
        // TODO: get proper image size (18 ins story board)
        suitImageView = UIImageView(frame: CGRect(x: 25 + rankLabel.frame.width + 10, y: 25, width: 25, height: 25))
        
        super.init(frame: frame)
        self.actionNameLabel.text = card.actionName
        self.actionNameLabel.textColor = UIColor.white
        self.actionNameLabel.textAlignment = NSTextAlignment.right

        self.actionDescLabel.text = card.actionDescription
        self.actionDescLabel.textColor = UIColor.gray
        self.actionDescLabel.textAlignment = NSTextAlignment.left
        self.actionDescLabel.numberOfLines = 0
        self.actionDescLabel.alpha = 0
        
        self.rankLabel.text = card.rank
        self.rankLabel.textColor = UIColor.white
        

        // TODO: set text and size
        self.backgroundColor = UIColor(white: 0, alpha: 0.75)
        
        self.addSubview(actionNameLabel)
        self.addSubview(actionDescLabel)
        self.addSubview(rankLabel)
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
