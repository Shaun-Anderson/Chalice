//
//  ViewController.swift
//  Overfloweth
//
//  Created by Shaun Anderson on 28/5/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var InformationView: UIView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var deck = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rankLabel.frame = CGRect(x: 25, y: 25, width: 25, height: 25)
        nameLabel.frame = CGRect(x: InformationView.frame.width - nameLabel.frame.width, y: 25, width: 300, height: 25)
        // Do any additional setup after loading the view, typically from a nib.
        
        deck = loadJson(filename: "Cards") as! [Card]
        
        DrawCard()
    }
    
    func DrawCard () {
        let randCard: Int = Int(arc4random_uniform(UInt32(deck.count)))
        let drewCard: Card = deck[randCard]
        print("Drew \(randCard): \(drewCard.rank)")
        
        rankLabel.text = drewCard.rank
        nameLabel.text = drewCard.actionName
        descriptionLabel.text = drewCard.actionDescription
        
        deck.remove(at: randCard)

    }
    
    func loadJson(filename fileName: String) -> [Card]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            print("NADS")
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                var tempDeck = [Card]()
                print(jsonData.Cards.count)
                var index: Int = 0
                for i in 0...3 {
                    for j in 0...jsonData.Cards.count-1 {
                        var newCard: Card = jsonData.Cards[j]
                        newCard.suit = SuitType.allValues[i]
                        tempDeck.append(newCard)
                        print("NEW CARD: \(newCard.rank) : \(newCard.suit)")
                        index += 1
                    }
                }
                return tempDeck
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DrawNew () {
        
    }


}

