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
class RuleCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {

    var index: Int?
    var titleLabel: PaddedUILabel
    var actionNameInput: PaddedTextField
    var actionDescInput: UITextView
    var backView: UIView
    
    var delegate: RuleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        titleLabel = PaddedUILabel(frame: CGRect.zero)
        actionNameInput = PaddedTextField(frame: CGRect.zero)
        actionDescInput = UITextView(frame: CGRect.zero)
        backView = UIView(frame: CGRect.zero)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        backView.backgroundColor = UIColor.red
        
        //titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.backgroundColor = UIColor.gray
        
        actionNameInput.attributedPlaceholder = NSAttributedString(string: "Action Name",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        actionNameInput.textColor = UIColor.white
        actionNameInput.delegate = self
        
        actionDescInput.backgroundColor = UIColor.clear
        actionDescInput.font = UIFont(name: "Helvetica", size: 16)
        actionDescInput.delegate = self
        
        addSubview(backView)
        addSubview(titleLabel)
        addSubview(actionNameInput)
        addSubview(actionDescInput)
        
    }
    
    override func layoutSubviews() {
        backView.frame = CGRect(x: 0, y: 0, width: 5, height: frame.height)
        titleLabel.frame = CGRect(x: 5, y: 0, width: self.frame.width, height: 30)
        actionNameInput.frame = CGRect(x: 5, y: 30, width: self.frame.width, height: 30)
        actionDescInput.frame = CGRect(x: 5, y: 60, width: self.frame.width, height: 60)
        actionNameInput.setBottomBorder(color: UIColor.white, size: 1)

        //errorCheck()
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
        
        if(actionDescInput.text!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            descClean = false
        } else {
            descClean = true
        }
        
        if(descClean && nameClean)
        {
            backView.backgroundColor = UIColor.green
        }
        else
        {
            backView.backgroundColor = UIColor.red
        }
    }
    
    override func prepareForReuse() {
        backView.backgroundColor = UIColor.red
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.descEditingFinished(index: index!, desc: textView.text!)
        errorCheck()
    }
}


