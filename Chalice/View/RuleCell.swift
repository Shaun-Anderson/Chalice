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
    var titleLabel: UILabel
    var actionNameInput: UITextField
    var actionDescInput: UITextView
    var backView: UIView
    
    var delegate: RuleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        titleLabel = UILabel(frame: CGRect.zero)
        actionNameInput = UITextField(frame: CGRect.zero)
        actionDescInput = UITextView(frame: CGRect.zero)
        backView = UIView(frame: CGRect.zero)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backView.layer.cornerRadius = 10
        backView.backgroundColor = UIColor.darkGray
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        
        actionNameInput.backgroundColor = UIColor.gray
        actionNameInput.placeholder = "Action Name"
        actionNameInput.textColor = UIColor.white
        actionNameInput.delegate = self
        
        actionDescInput.backgroundColor = UIColor.orange
        actionDescInput.font = UIFont(name: "Helvetica", size: 16)
        actionDescInput.delegate = self
        
        addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(actionNameInput)
        backView.addSubview(actionDescInput)
        
    }
    
    override func layoutSubviews() {
        backView.frame = CGRect(x: 5, y: 5, width: frame.width - 10, height: frame.height - 10)
        titleLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        actionNameInput.frame = CGRect(x: 60, y: 0, width: self.frame.width - 100, height: 30)
        actionDescInput.frame = CGRect(x: 60, y: 30, width: self.frame.width - 100, height: 60)
        errorCheck()
    }
    
    func errorCheck() {
        var nameClean = false
        var descClean = false
        // Empty Checks
        if(actionNameInput.text!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            backView.backgroundColor = UIColor.yellow
            nameClean = false
        } else {
            backView.backgroundColor = UIColor.green
            nameClean = true
        }
        
        if(actionDescInput.text!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            backView.backgroundColor = UIColor.yellow
            descClean = false
        } else {
            backView.backgroundColor = UIColor.green
            descClean = true
        }
    }
    
    override func prepareForReuse() {
        backView.backgroundColor = UIColor.darkGray
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
