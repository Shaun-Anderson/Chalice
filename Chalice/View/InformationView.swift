//
//  InformationView.swift
//  Overfloweth
//
//  Created by Shaun Anderson on 29/5/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

class InformationView: UIView {
    
    // MARK: - Properties
    
    var helpLabel: UILabel
    var actionNameLabel: UILabel
    var actionDescLabel: UILabel
    var rankLabel: UILabel
    var suitImageView: UIImageView
    
    // MARK: - Initialisaiton
    
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

        guard let regularFont = UIFont(name: "QuicksandBook-Regular", size: UIFont.labelFontSize) else {
            fatalError("Failed to load the CustomFont-Light font.")
        }
        guard let lightFont = UIFont(name: "NordicaThin", size: UIFont.labelFontSize) else {
            fatalError("Could not find font")
        }
        
        super.init(frame: frame)
        isUserInteractionEnabled = false

        self.helpLabel.text = "---> Swipe to continue."
        self.helpLabel.textColor = UIColor.white
        self.helpLabel.textAlignment = NSTextAlignment.right
        self.helpLabel.alpha = 0
        self.helpLabel.font = lightFont
        helpLabel.font = helpLabel.font.withSize(14)


        self.actionNameLabel.text = card.actionName.uppercased()
        self.actionNameLabel.textColor = UIColor.white
        self.actionNameLabel.textAlignment = NSTextAlignment.right
        self.actionNameLabel.alpha = 0
        self.actionNameLabel.font = lightFont
        
        self.actionDescLabel.text = card.actionDescription
        self.actionDescLabel.textColor = UIColor.gray
        self.actionDescLabel.textAlignment = NSTextAlignment.left
        self.actionDescLabel.numberOfLines = 5
        self.actionDescLabel.alpha = 0
        

        self.actionDescLabel.font = lightFont
        actionDescLabel.font = helpLabel.font.withSize(14)
        
        // TODO: set text and size
        self.backgroundColor = UIColor(white: 0, alpha: 0.75)
        
        self.addSubview(actionNameLabel)
        self.addSubview(actionDescLabel)
        self.addSubview(helpLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        actionDescLabel.sizeToFit()
    }
    
    // TODO: add extra animations if needed
    public func AnimateInUI ()
    {
        helpLabel.frame = CGRect(x: 25, y: frame.height - 50, width: frame.height, height: 25)
        actionDescLabel.frame = CGRect(x: 25, y: 75, width: frame.width - 50, height: frame.height-150)
        UIView.animate(withDuration: 0.5, animations: {
            self.actionDescLabel.alpha = 1
            self.actionNameLabel.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
            self.helpLabel.alpha = 1
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
