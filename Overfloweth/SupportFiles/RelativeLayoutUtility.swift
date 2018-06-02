//
//  RelativeLayoutUtility.swift
//  Overfloweth
//
//  Created by Shaun Anderson on 2/6/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

class RelativeLayoutUtility {
    
    var heightFrame: CGFloat?
    var widthFrame: CGFloat?
    
    init(referenceFrameSize: CGSize){
        heightFrame = referenceFrameSize.height
        widthFrame = referenceFrameSize.width
    }
    
    func relativeHeight(multiplier: CGFloat) -> CGFloat{
        
        return multiplier * self.heightFrame!
    }
    
    func relativeWidth(multiplier: CGFloat) -> CGFloat{
        return multiplier * self.widthFrame!
        
    }
}
