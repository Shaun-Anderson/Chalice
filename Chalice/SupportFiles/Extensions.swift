//
//  Extensions.swift
//  Overfloweth
//
//  Created by Shaun Anderson on 29/5/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import Foundation
import UIKit

extension MutableCollection {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        for i in indices.dropLast() {
            let diff = distance(from: i, to: endIndex)
            let j = index(i, offsetBy: numericCast(arc4random_uniform(numericCast(diff))))
            swapAt(i, j)
        }
    }
}

extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffled() -> [Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
}

extension UITextField
{
    func setBottomBorder(color:UIColor, size: CGFloat)
    {
        self.borderStyle = UITextBorderStyle.none;
        let border = CALayer()
        let width: CGFloat = size
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}

