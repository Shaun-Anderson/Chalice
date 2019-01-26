//
//  PlaceHolderTextView.swift
//  Chalice
//
//  Created by Shaun Anderson on 13/1/19.
//  Copyright © 2019 Shaun Anderson. All rights reserved.
//

import UIKit


protocol PlaceHolderTextViewDelegate {
    func didBeginEditing(_ textView:PlaceHolderTextView)
    func didEndEditing(_ textView:PlaceHolderTextView)
}
class PlaceHolderTextView: UITextView, PlaceHolderTextViewDelegate {
    func didBeginEditing(_ textView: PlaceHolderTextView) {
        print("Begin")
        placeHolderDelegate?.didBeginEditing(textView)
    }
    
    func didEndEditing(_ textView: PlaceHolderTextView) {
        print("End")
        placeHolderDelegate?.didEndEditing(textView)
    }
    
    var placeholderText: String!
    var placeHolderDelegate: PlaceHolderTextViewDelegate?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup()
    {
        text = placeholderText
        textColor = UIColor.lightGray
    }
    
}
