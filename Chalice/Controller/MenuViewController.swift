//
//  MenuViewController.swift
//  Overfloweth
//
//  Created by Shaun Anderson on 2/6/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var playButton: UIButton?
    var createButton: UIButton?
    var rateButton: UIButton?
    var optionsButton: UIButton?
    var mainImage: UIImageView?
    var titleLabel: UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 14/255, green: 1/255, blue: 26/255, alpha: 1)

        // Main image
        mainImage = UIImageView(frame: CGRect(x: 25, y: 200, width: 50, height: 50))
        mainImage?.image = #imageLiteral(resourceName: "SplashScreenImage")
        mainImage?.alpha = 0
        view.addSubview(mainImage!)
        
        // Title label
        titleLabel = UILabel(frame: CGRect(x: 75, y: 200, width: view.frame.width, height: 50))
        titleLabel?.text = "CHALICE"
        titleLabel?.textColor = UIColor.white
        titleLabel?.alpha = 0
        guard let customFont = UIFont(name: "NordicaThin", size: 32) else {
            fatalError("""
        Failed to load the "CustomFont-Light" font.
        Make sure the font file is included in the project and the font name is spelled correctly.
        """
            )
        }
        titleLabel?.font = customFont
        //titleLabel?.adjustsFontForContentSizeCategory = true
        view.addSubview(titleLabel!)
        
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.mainImage?.alpha = 1
            self.titleLabel?.alpha = 1
        }, completion: { _ in
            // Create play button.
            self.playButton = UIButton(frame: CGRect(x: 25, y: self.view.frame.height/2, width: 100, height: 150))
            self.playButton?.backgroundColor = UIColor.white
            self.playButton?.fullyRound(diameter: 30)
            self.playButton?.setTitleColor(UIColor.black, for: .normal)
            self.playButton?.setTitle("Play", for: .normal)
            self.playButton?.addTarget(self, action:#selector(self.MoveToPlay), for: .touchUpInside)
            self.view.addSubview(self.playButton!)
            
            self.createButton = UIButton(frame: CGRect(x: 130, y: self.view.frame.height/2, width: 100, height: 150))
            self.createButton?.fullyRound(diameter: 30)
            self.createButton?.backgroundColor = UIColor.white
            self.createButton?.setTitleColor(UIColor.black, for: .normal)
            self.createButton?.setTitle("Desks", for: .normal)
            self.createButton?.addTarget(self, action:#selector(self.MoveToCreate), for: .touchUpInside)
            self.view.addSubview(self.createButton!)
            
            self.rateButton = UIButton(frame: CGRect(x: 235, y: self.view.frame.height/2, width: 100, height: 150))
            self.rateButton?.backgroundColor = UIColor.green
            self.rateButton?.fullyRound(diameter: 30)
            self.rateButton?.setTitleColor(UIColor.black, for: .normal)
            self.rateButton?.setTitle("Rate", for: .normal)
            self.rateButton?.addTarget(self, action:#selector(self.rateButtonPressed), for: .touchUpInside)
            self.view.addSubview(self.rateButton!)
            
            self.optionsButton = UIButton(frame: CGRect(x: self.view.frame.width - 100, y: self.view.frame.height - 100, width: 50, height: 50))
            self.optionsButton?.backgroundColor = UIColor.green
            self.optionsButton?.fullyRound(diameter: 30)
            self.optionsButton?.setTitleColor(UIColor.black, for: .normal)
            self.optionsButton?.setTitle("Options", for: .normal)
            self.optionsButton?.addTarget(self, action:#selector(self.rateButtonPressed), for: .touchUpInside)
            self.view.addSubview(self.optionsButton!)
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func MoveToPlay (sender: UIButton)
    {
        let nextVC = DeckListViewController()
        nextVC.toGame = true
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc func MoveToCreate (sender: UIButton)
    {
        let nextVC = DeckListViewController()
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc func rateButtonPressed (sender: UIButton)
    {
    }

}
