//
//  ProgressView.swift
//  Chalice
//
//  Created by Shaun Anderson on 29/6/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

/// A simple rating view that can set whole, half or floating point ratings.
@IBDesignable
@objcMembers
open class ProgressView: UIView {
    
    // MARK: Properties
    /// Array of empty image views
    private var emptyImageViews: [UIImageView] = []
    
    /// Array of full image views
    private var fullImageViews: [UIImageView] = []
    
    /// Sets the empty image (e.g. a star outline)
    @IBInspectable open var emptyImage: UIImage? {
        didSet {
            // Update empty image views
            for imageView in emptyImageViews {
                imageView.image = emptyImage
            }
            refresh()
        }
    }
    
    /// Sets the full image that is overlayed on top of the empty image.
    /// Should be same size and shape as the empty image.
    @IBInspectable open var fullImage: UIImage? {
        didSet {
            // Update full image views
            for imageView in fullImageViews {
                imageView.image = fullImage
            }
            refresh()
        }
    }
    
    /// Sets the empty and full image view content mode.
    open var imageContentMode: UIViewContentMode = UIViewContentMode.scaleAspectFit
    
    /// Minimum rating.
    @IBInspectable open var minRating: Int  = 0 {
        didSet {
            // Update current rating if needed
            if rating < Double(minRating) {
                rating = Double(minRating)
                refresh()
            }
        }
    }
    
    var cardNumberLabel: UILabel?
    open var cardsRemaining: Int = 54 {
        didSet {
            cardNumberLabel?.text = String(self.cardsRemaining)
        }
    }
    
    /// Max rating value.
    @IBInspectable open var maxRating: Int = 4 {
        didSet {
            if maxRating != oldValue {
                removeImageViews()
                initImageViews()
                
                // Relayout and refresh
                setNeedsLayout()
                refresh()
            }
        }
    }
    
    /// Minimum image size.
    @IBInspectable open var minImageSize: CGSize = CGSize(width: 5.0, height: 5.0)
    
    /// Set the current rating.
    @IBInspectable open var rating: Double = 0 {
        didSet {
            if rating != oldValue {
                refresh()
            }
        }
    }
    
    /// Sets whether or not the rating view can be changed by panning.
    @IBInspectable open var editable: Bool = true
    
    // MARK: Type
    @objc public enum FloatRatingViewType: Int {
        /// Integer rating
        case wholeRatings
        /// Double rating in increments of 0.5
        case halfRatings
        /// Double rating
        case floatRatings
        
        /// Returns true if rating can contain decimal places
        func supportsFractions() -> Bool {
            return self == .halfRatings || self == .floatRatings
        }
    }
    
    /// Float rating view type
    @IBInspectable open var type: FloatRatingViewType = .wholeRatings
    
    // MARK: Initializations
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        
        initImageViews()
        
        cardNumberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        cardNumberLabel?.textAlignment = NSTextAlignment.center
        cardNumberLabel?.textColor = UIColor.gray
        addSubview(cardNumberLabel!)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initImageViews()
    }
    
    // MARK: Helper methods
    private func initImageViews() {
        guard emptyImageViews.isEmpty && fullImageViews.isEmpty else {
            return
        }
        
        // Add new image views
        for _ in 0..<maxRating {
            let emptyImageView = UIImageView()
            emptyImageView.contentMode = imageContentMode
            emptyImageView.image = emptyImage
            emptyImageView.alpha = 0
            emptyImageViews.append(emptyImageView)
            addSubview(emptyImageView)
            
            let fullImageView = UIImageView()
            fullImageView.contentMode = imageContentMode
            fullImageView.image = fullImage
            fullImageView.alpha = 0
            fullImageViews.append(fullImageView)
            addSubview(fullImageView)
            

        }
        
    }
    
    private func removeImageViews() {
        // Remove old image views
        for i in 0..<emptyImageViews.count {
            var imageView = emptyImageViews[i]
            imageView.removeFromSuperview()
            imageView = fullImageViews[i]
            imageView.removeFromSuperview()
        }
        emptyImageViews.removeAll(keepingCapacity: false)
        fullImageViews.removeAll(keepingCapacity: false)
    }
    
    // Refresh hides or shows full images
    private func refresh() {
        for i in 0..<fullImageViews.count {
            let imageView = fullImageViews[i]
            
            if rating >= Double(i+1) {
                imageView.layer.mask = nil
                imageView.isHidden = false
            } else if rating > Double(i) && rating < Double(i+1) {
                // Set mask layer for full image
                let maskLayer = CALayer()
                maskLayer.frame = CGRect(x: 0, y: 0, width: 50, height: imageView.frame.size.height)
                maskLayer.backgroundColor = UIColor.black.cgColor
                imageView.layer.mask = maskLayer
                imageView.isHidden = false
            } else {
                imageView.layer.mask = nil;
                imageView.isHidden = true
            }
        }
    }
    
    // Calculates the ideal ImageView size in a given CGSize
    private func sizeForImage(_ image: UIImage, inSize size: CGSize) -> CGSize {
        let imageRatio = image.size.width / image.size.height
        let viewRatio = size.width / size.height
        
        if imageRatio < viewRatio {
            let scale = size.height / image.size.height
            let width = scale * image.size.width
            
            return CGSize(width: width, height: size.height)
        } else {
            let scale = size.width / image.size.width
            let height = scale * image.size.height
            
            return CGSize(width: size.width, height: height)
        }
    }
    
    
    // MARK: UIView
    
    // Override to calculate ImageView frames
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        guard let emptyImage = emptyImage else {
            return
        }
        
        let desiredImageWidth = frame.size.width - 25
        let maxImageWidth = max(minImageSize.width, desiredImageWidth)
        let maxImageHeight = max(minImageSize.height, frame.size.height)
        let imageViewSize = sizeForImage(fullImage!, inSize: CGSize(width: maxImageWidth, height: maxImageHeight))
        let imageXOffset = CGFloat(0)
        
        for i in 0..<maxRating {
            let imageFrame = CGRect(x: 12.5, y: i == 0 ? frame.height/2 - 100 : (frame.height/2 - 100) + CGFloat(i)*(imageXOffset+imageViewSize.height), width: imageViewSize.width, height: imageViewSize.height)
            
            var imageView = emptyImageViews[i]
            imageView.frame = imageFrame
            
            imageView = fullImageViews[i]
            imageView.frame = imageFrame
        }
        var delayTime : Double = 0
        for imageView in fullImageViews {
            
            UIView.animate(withDuration: 0.5, delay: delayTime, animations: {
                imageView.alpha = 1
            })
            delayTime += 0.5
        }
        refresh()
    }
    
}
