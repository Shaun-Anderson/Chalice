//
//  RuleCellTableViewCell.swift
//  Chalice
//
//  Created by Shaun Anderson on 1/7/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit
protocol RuleCellDelegate {
    func nameEditingFinished (index: Int, name: String)
    func descEditingFinished (index: Int, desc: String)
}
class RuleCell: UITableViewCell, UITextFieldDelegate, PlaceHolderTextViewDelegate {

    var index : Int?
    var titleLabel : PaddedUILabel
    var actionNameInput : PaddedTextField
    var actionDescInput : PlaceHolderTextView
    var validView : UIView
    var backView : UIView
    
    var delegate: RuleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        titleLabel = PaddedUILabel(frame: CGRect.zero)
        actionNameInput = PaddedTextField(frame: CGRect.zero)
        actionDescInput = PlaceHolderTextView(frame: CGRect.zero)
        //actionDescInput = PlaceHolderTextView(frame: CGRect.zero, textContainer: nil, placeholder: "hi")

        // Valid view
        validView = UIView(frame: CGRect.zero)
        //validView.round(corners: [.topRight], radius: 10)
        validView.backgroundColor = UIColor.red

        // Back view
        backView = UIView(frame: CGRect.zero)
        backView.fullyRound(diameter: 30)
        backView.backgroundColor = UIColor.white
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        
        titleLabel.textColor = UIColor.black
        titleLabel.backgroundColor = UIColor.white
        actionNameInput.attributedPlaceholder = NSAttributedString(string: "Action Name",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        actionNameInput.textColor = UIColor.black
        actionNameInput.delegate = self

        actionDescInput.backgroundColor = UIColor.clear
        actionDescInput.font = UIFont(name: "Helvetica", size: 14)
        
        actionDescInput.placeHolderDelegate = self
        actionDescInput.textColor = UIColor.darkGray
        
        addSubview(backView)
        backView.addSubview(validView)
        backView.addSubview(titleLabel)
        backView.addSubview(actionNameInput)
        backView.addSubview(actionDescInput)
        
    }
    
    override func layoutSubviews() {
        backView.frame = CGRect(x: 5, y: 5, width: self.frame.width - 10, height: self.frame.height - 5 )
        validView.frame = CGRect(x: 0, y: self.frame.height/2, width: 10, height: 10)
        validView.layer.cornerRadius = 10
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 30)
        actionNameInput.frame = CGRect(x: 10, y: 30, width: self.frame.width, height: 30)
        actionDescInput.frame = CGRect(x: 10, y: 60, width: self.frame.width, height: 60)
        actionNameInput.setBottomBorder(color: UIColor.black, size: 2)
        
        actionDescInput.placeholderText = "Description"
        actionDescInput.setup()
    }
    
    func errorCheck() {
        var nameClean = false
        var descClean = false
        // Empty Checks
        if(actionNameInput.text!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            nameClean = false
        } else {
            nameClean = true
        }
        
        if actionDescInput.text!.trimmingCharacters(in: .whitespaces).isEmpty
        {
            descClean = false
        } else {
            descClean = true
        }
        
        if descClean && nameClean
        {
            validView.backgroundColor = UIColor.green
        }
        else
        {
            validView.backgroundColor = UIColor.red
        }
    }
    
    override func prepareForReuse() {
        validView.backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITextFieldDelegate Functions
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.nameEditingFinished(index: index!, name: textField.text!)
        errorCheck()
    }
    
    // MARK: - UITextViewDelegate Functions
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
//        
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = placeholderText
//            textView.textColor = UIColor.lightGray
//        }
//        delegate?.descEditingFinished(index: index!, desc: textView.text!)
//        errorCheck()
//    }
    
    func didBeginEditing(_ textView: PlaceHolderTextView) {
        
    }
    
    func didEndEditing(_ textView: PlaceHolderTextView) {
    
    }
}


