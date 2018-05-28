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
        self.topText = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.topSuit = UIImageView(frame: CGRect(x: 12.5, y: 50, width: 25, height: 25))
        self.bottomText = UILabel(frame: CGRect(x: frame.width - 100, y: frame.height - 100, width: 50, height: 50))
        self.bottomSuit = UIImageView(frame: CGRect(x: 12.5, y: frame.height - 200, width: 25, height: 25))
        self.card = card
        super.init(frame: frame)
        
        // Set UI specifcs
        self.layer.cornerRadius = 10;
        self.topText.text = card.rank
        self.topSuit.image = UIImage(named: (card.suit?.rawValue)!)
        self.bottomText.text = card.rank
        self.bottomSuit.image = UIImage(named: (card.suit?.rawValue)!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
