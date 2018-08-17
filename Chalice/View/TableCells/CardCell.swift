//
//  CardCell.swift
//  Overfloweth
//
//  Created by Shaun Anderson on 30/5/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

protocol CardCellDelegate {
    func RevealCard(view: UIView, card: CardCell)
    func DismissCard(card: CardCell)
}
class CardCell: UICollectionViewCell {
    
    var backView: UIView
    var frontView: UIView
    
    var card: Card?
    var delegate: CardCellDelegate?
    var revealed: Bool
    var originalCenter: CGPoint!
    var indexPath: IndexPath?
    
    var topText: UILabel
    var topSuit: UIImageView
    var bottomText: UILabel
    var bottomSuit: UIImageView
    
    var panGesture: UIPanGestureRecognizer
    var leftSwipeGesture: UISwipeGestureRecognizer
    var rightSwipeGesture: UISwipeGestureRecognizer

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        self.revealed = false
        // Create the sides of the cards.
        backView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        frontView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        frontView.isHidden = true;
        // Create UI elements
        topText = UILabel(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        topSuit = UIImageView(frame: CGRect(x: 37.5, y: 75, width: 15, height: 15))
        bottomText = UILabel(frame: CGRect(x: frame.width - 75, y: frame.height - 75, width: 50, height: 50))
        bottomSuit = UIImageView(frame: CGRect(x: frame.width - 63.5, y: frame.height - 100, width: 15, height: 15))
        
        frontView.addSubview(topText)
        frontView.addSubview(topSuit)
        frontView.addSubview(bottomText)
        frontView.addSubview(bottomSuit)
        let backCardImage = UIImageView(frame: CGRect(x: 0, y: 0, width: backView.frame.width, height: backView.frame.height))
        backCardImage.image = #imageLiteral(resourceName: "CardBack")
        backCardImage.layer.masksToBounds = true
        backCardImage.layer.cornerRadius = 12
        backView.addSubview(backCardImage)
        panGesture = UIPanGestureRecognizer()
        leftSwipeGesture = UISwipeGestureRecognizer()
        rightSwipeGesture = UISwipeGestureRecognizer()

        guard let boldFont = UIFont(name: "QuicksandBook-Regular", size: UIFont.labelFontSize) else {
            fatalError("""
        Failed to load the "CustomFont-Light" font.
        Make sure the font file is included in the project and the font name is spelled correctly.
        """
            )
        }
        
        super.init(frame: frame)
        
        self.topText.font = boldFont
        self.bottomText.font = boldFont

        self.addSubview(backView)
        self.addSubview(frontView)
                
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(SwipeDown(_:)))
        self.addGestureRecognizer(panGesture)
        self.panGesture.isEnabled = false
        self.layer.cornerRadius = 12
        self.backgroundColor = UIColor.darkGray
        
        leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(SwipeLeft(_:)))
        leftSwipeGesture.direction = .left
        self.addGestureRecognizer(leftSwipeGesture)
        
        rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(SwipeRight(_:)))
        rightSwipeGesture.direction = .right
        self.addGestureRecognizer(rightSwipeGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewCell
    
    override func prepareForReuse() {
        self.backView.isHidden = false
        self.backgroundColor = UIColor.white
        self.frontView.isHidden = true
        revealed = false
        topText.text = ""
        topSuit.image = nil
        bottomText.text = ""
        bottomSuit.image = nil
        //self.gestureRecognizers?.remove(at: 2)
        self.leftSwipeGesture.isEnabled = true
        self.panGesture.isEnabled = false
    }
    
    // MARK: - Other functions
    
    func Reveal () {
        revealed = true
        if(card?.rank == "K")
        {
            self.backgroundColor = Constants.kingColor

        }
        else
        {
            self.backgroundColor = UIColor.white
        }
        self.frontView.isHidden = false
        self.backView.isHidden = true
        self.leftSwipeGesture.isEnabled = false
        
        topText.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        topSuit.frame = CGRect(x: topText.center.x - 7.5, y: 75, width: 15, height: 15)
        bottomText.frame = CGRect(x: frame.width - 75, y: frame.height - 75, width: 50, height: 50)
        bottomSuit.frame = CGRect(x: bottomText.center.x - 7.5, y: bottomText.frame.origin.y - 15, width: 15, height: 15)
        
        // Set UI specifcs
        topText.text = card?.rank
        topText.textAlignment = NSTextAlignment.center
        topSuit.image = UIImage(named: (card?.suit?.rawValue)!)
        topSuit.tintColor = UIColor.darkGray
        bottomText.text = card?.rank
        bottomText.textAlignment = NSTextAlignment.center
        bottomSuit.image = UIImage(named: (card?.suit?.rawValue)!)
        bottomSuit.tintColor = UIColor.darkGray
        bottomText.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        bottomSuit.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
    
    // Take the values of the currcent swipe
    @objc func SwipeLeft(_ gestureRecognizer: UISwipeGestureRecognizer) {
        originalCenter = self.center
        delegate!.RevealCard(view: self, card: self)
        Reveal()
        print("nihuihiuhiu")
    }
    // Take the values of the currcent swipe
    @objc func SwipeRight(_ gestureRecognizer: UISwipeGestureRecognizer) {
        print(revealed)
        if(!revealed)
        {
            originalCenter = self.center
            delegate!.RevealCard(view: self, card: self)
            Reveal()
        }
        else
        {
            print("iugiugiugiu")
            delegate!.DismissCard(card: self)
        }
    }
    // Take the values of the currcent swipe
    @objc func SwipeDown(_ gestureRecognizer: UIPanGestureRecognizer) {
        var yDir = gestureRecognizer.translation(in: self).y
        if(revealed && yDir > 100)
        {
            delegate!.DismissCard(card: self)
        }
    }
}
