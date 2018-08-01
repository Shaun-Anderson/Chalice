//
//  PaddedUILabel.swift
//  Chalice
//
//  Created by Shaun Anderson on 1/8/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

class PaddedUILabel: UILabel {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
        
    }
}
