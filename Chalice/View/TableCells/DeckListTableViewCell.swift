//
//  DeckListTableViewCell.swift
//  Chalice
//
//  Created by Shaun Anderson on 1/8/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

class DeckListTableViewCell: UITableViewCell {

    var name : String?
    var deckNameLabel: UILabel?{
        didSet{
            name = deckNameLabel?.text
        }
    }
    var editButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        deckNameLabel = UILabel(frame: CGRect.zero)
        editButton = UIButton(frame: CGRect.zero)
        super .init(style: style, reuseIdentifier: reuseIdentifier)


        editButton?.setTitle("/", for: .normal)
        editButton?.setTitleColor(UIColor.black, for: .normal)
        editButton?.backgroundColor = UIColor.yellow

        self.addSubview(deckNameLabel!)
        self.addSubview(editButton!)
    }
    
    override func layoutSubviews() {
        
        deckNameLabel?.frame = CGRect(x: 10, y: 0, width: self.frame.width - 51, height: self.frame.height)
        editButton?.frame = CGRect(x: self.frame.width - 50, y: 0, width: 50, height: 50)
        
        if(deckNameLabel?.text == "Default" )
        {
            backgroundColor = UIColor.gray
            editButton?.isHidden = true;
        }
        
        if(deckNameLabel?.text == "+")
        {
            backgroundColor = UIColor.green
            editButton?.isHidden = true
            deckNameLabel?.textAlignment = .center
            deckNameLabel?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        }
        

    }
    
    override func prepareForReuse() {
        editButton?.isHidden = false;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
