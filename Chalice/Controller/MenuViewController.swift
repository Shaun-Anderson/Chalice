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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        playButton?.addTarget(self, action:#selector(MoveToPlay), for: .touchUpInside)
        playButton?.backgroundColor = UIColor.black
        self.view.addSubview(playButton!)
        // Do any additional setup after loading the view.
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
