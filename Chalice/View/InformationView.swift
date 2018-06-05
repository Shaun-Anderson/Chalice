//
//  InformationView.swift
//  Overfloweth
//
//  Created by Shaun Anderson on 29/5/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

class InformationView: UIView {
    var helpLabel: UILabel
    var actionNameLabel: UILabel
    var actionDescLabel: UILabel
    var rankLabel: UILabel
    var suitImageView: UIImageView
    
    init(frame: CGRect, card: Card) {
        helpLabel = UILabel(frame: CGRect.zero)
        actionNameLabel = UILabel(frame: CGRect(x: frame.width - 325, y: 25, width: 300, height: 25))
        actionDescLabel = UILabel(frame: CGRect(x: 25, y: 150, width: frame.width - 50, height: 100))
        rankLabel = UILabel(frame: CGRect(x: 25, y: 25, width: 25, height: 25))
        // TODO: get proper image size (18 ins story board)
        suitImageView = UIImageView(frame: CGRect(x: 25 + rankLabel.frame.width + 10, y: 25, width: 25, height: 25))
        
        guard let boldFont = UIFont(name: "Helvetica-Bold", size: 18) else {
            fatalError("Could not find font")
        }
        guard let regualarFont = UIFont(name: "Helvetica", size: UIFont.labelFontSize) else {
            fatalError("Could not find font")
        }
        guard let lightFont = UIFont(name: "Helvetica-Light", size: UIFont.labelFontSize) else {
            fatalError("Could not find font")
        }
        
        super.init(frame: frame)
        isUserInteractionEnabled = false

        self.helpLabel.text = "Swipe down to continue"
        self.helpLabel.textColor = UIColor.white
        self.helpLabel.textAlignment = NSTextAlignment.center
        self.helpLabel.alpha = 0
        self.helpLabel.font = lightFont

        self.actionNameLabel.text = card.actionName
        self.actionNameLabel.textColor = UIColor.white
        self.actionNameLabel.textAlignment = NSTextAlignment.right
        self.actionNameLabel.font = boldFont
        
        self.actionDescLabel.text = card.actionDescription
        self.actionDescLabel.textColor = UIColor.gray
        self.actionDescLabel.textAlignment = NSTextAlignment.left
        self.actionDescLabel.numberOfLines = 0
        self.actionDescLabel.alpha = 0
        self.actionDescLabel.font = regualarFont
        
        self.rankLabel.text = card.rank
        self.rankLabel.textColor = UIColor.white
        self.rankLabel.textAlignment = NSTextAlignment.right
        self.rankLabel.font = boldFont
        
        self.suitImageView.image = UIImage(named: (card.suit?.rawValue)!)
        
        // TODO: set text and size
        self.backgroundColor = UIColor(white: 0, alpha: 0.75)
        
        self.addSubview(actionNameLabel)
        self.addSubview(actionDescLabel)
        self.addSubview(rankLabel)
        self.addSubview(suitImageView)
        self.addSubview(helpLabel)
    }
    
    // TODO: add extra animations if needed
    public func AnimateInUI ()
    {
        helpLabel.frame = CGRect(x: 25, y: frame.height - 50, width: frame.height - 10, height: 25)
        actionDescLabel.frame = CGRect(x: 25, y: 50, width: frame.width - 50, height: frame.height-150)
        UIView.animate(withDuration: 0.5, animations: {
            self.actionDescLabel.alpha = 1
            self.helpLabel.alpha = 1
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
