//
//  CardView.swift
//  Overfloweth
//
//  Created by Shaun Anderson on 28/5/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

class CardView: UIView {

    // MARK: Variables
    var card: Card
    var topText: UILabel
    var topSuit: UIImageView
    var bottomText: UILabel
    var bottomSuit: UIImageView
    
    //MARK: Initialization
    init(frame: CGRect, card: Card) {
        
        // Create UI elements
        self.topText = UILabel(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        self.topSuit = UIImageView(frame: CGRect(x: 37.5, y: 75, width: 25, height: 25))
        self.bottomText = UILabel(frame: CGRect(x: frame.width - 75, y: frame.height - 75, width: 50, height: 50))
        self.bottomSuit = UIImageView(frame: CGRect(x: frame.width - 63.5, y: frame.height - 100, width: 25, height: 25))
        self.card = card
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

        // Set UI specifcs
        self.topText.text = card.rank
        self.topText.textAlignment = NSTextAlignment.center
        self.topSuit.image = UIImage(named: (card.suit?.rawValue)!)
        self.bottomText.text = card.rank
        self.bottomText.textAlignment = NSTextAlignment.center
        self.bottomSuit.image = UIImage(named: (card.suit?.rawValue)!)
        bottomText.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        bottomSuit.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        self.addSubview(topText)
        self.addSubview(topSuit)
        self.addSubview(bottomText)
        self.addSubview(bottomSuit)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 10
    }
}
