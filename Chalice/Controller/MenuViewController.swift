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

        mainImage = UIImageView(frame: CGRect(x: view.frame.width/2-75, y: view.frame.height/2-150, width: 150, height: 150))
        mainImage?.image = #imageLiteral(resourceName: "SplashScreenImage")
        view.addSubview(mainImage!)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 100))
        titleLabel?.textAlignment = .center
        titleLabel?.text = "CHALICE"
        titleLabel?.textColor = UIColor.white
        guard let customFont = UIFont(name: "NordicaThin", size: UIFont.labelFontSize) else {
            fatalError("""
        Failed to load the "CustomFont-Light" font.
        Make sure the font file is included in the project and the font name is spelled correctly.
        """
            )
        }
        titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
        titleLabel?.adjustsFontForContentSizeCategory = true
        
        view.addSubview(titleLabel!)
        
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.mainImage?.alpha = 1
            self.mainImage?.center.y = 150
        }, completion: { _ in
            // Create play button.
            self.playButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 50))
            self.playButton?.backgroundColor = UIColor.white
            self.playButton?.setTitleColor(UIColor.black, for: .normal)
            self.playButton?.setTitle("Play", for: .normal)
            self.playButton?.addTarget(self, action:#selector(self.MoveToPlay), for: .touchUpInside)
            self.view.addSubview(self.playButton!)
            
            self.createButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height/2 + 100, width: self.view.frame.width, height: 50))
            self.createButton?.backgroundColor = UIColor.white
            self.createButton?.setTitleColor(UIColor.black, for: .normal)
            self.createButton?.setTitle("Desks", for: .normal)
            self.createButton?.addTarget(self, action:#selector(self.MoveToCreate), for: .touchUpInside)
            self.view.addSubview(self.createButton!)
            
            self.rateButton = UIButton(frame: CGRect(x: 50, y: self.view.frame.height - 200, width: 100, height: 50))
            self.rateButton?.backgroundColor = UIColor.green
            self.rateButton?.setTitleColor(UIColor.black, for: .normal)
            self.rateButton?.setTitle("Rate", for: .normal)
            self.rateButton?.addTarget(self, action:#selector(self.rateButtonPressed), for: .touchUpInside)
            self.view.addSubview(self.rateButton!)
            
            self.optionsButton = UIButton(frame: CGRect(x: 200, y: self.view.frame.height - 200, width: 100, height: 50))
            self.optionsButton?.backgroundColor = UIColor.green
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
        let nextVC = NewViewController()
        nextVC.ruleSet = loadJson(filename: "Default")
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc func MoveToCreate (sender: UIButton)
    {
        let nextVC = DeckListViewController()
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc func rateButtonPressed (sender: UIButton)
    {
    }
    

    
    func loadJson(filename: String) -> ResponseData {
        if(filename == "Default") {
            if let url = Bundle.main.url(forResource: filename, withExtension: "json") {
                print("NADS")
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(ResponseData.self, from: data)
                    return jsonData
                } catch {
                    print("error:\(error)")
                }
            }
        }
//        else {
//            let fileManager = FileManager.default
//            do{
//                // TODO Check if exisitng.
//                let path = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
//                let fileURL = path.appendingPathComponent(filename).appendingPathExtension("json")
//                // Set the data we want to write
//                do {
//                    let data = try Data(contentsOf: URL(fileURLWithPath: fileURL.path), options: .mappedIfSafe)
//                    //                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                    //                    print(jsonResult)
//                    let decoder = JSONDecoder()
//                    let jsonData = try decoder.decode(ResponseData.self, from: data)
//                    var tempDeck = [Card]()
//                    print(jsonData.Cards.count)
//                    var index: Int = 0
//                    for i in 0...3 {
//                        for j in 0...jsonData.Cards.count-1 {
//                            var newCard: Card = jsonData.Cards[j]
//                            newCard.suit = SuitType.allValues[i]
//                            tempDeck.append(newCard)
//                            index += 1
//                        }
//                    }
//                    return tempDeck
//                } catch let error {
//                    print("parse error: \(error.localizedDescription)")
//                }
//            }
//            catch
//            {
//                print("FILE ERROR")
//            }
//        }
        return ResponseData(Title: "", Cards: [])

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
