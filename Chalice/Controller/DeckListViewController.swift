//
//  DeckListViewController.swift
//  Chalice
//
//  Created by Shaun Anderson on 1/8/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

class DeckListViewController: UIViewController {

    // MARK: - Properties
    
    var decksNames : [String] = []
    var toGame : Bool = false
    
    var tableView : UITableView?
    var backButton : UIButton?
    var createButton : UIButton?
    var titleLabel : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        decksNames = loadDeckNames()
        
        var y = UIApplication.shared.statusBarFrame.height
        
        // Set back button
        backButton = UIButton(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        backButton?.setImage(#imageLiteral(resourceName: "CrossIcon"), for: .normal)
        backButton?.tintColor = UIColor.red
        backButton?.addTarget(self, action: #selector(self.cancelButtonPressed), for: .touchUpInside)
        
        // Create Button
        createButton = UIButton(frame: CGRect(x: self.view.frame.width - 75, y: 25, width: 50, height: 50))
        createButton?.setTitle("+", for: .normal)
        createButton?.setTitleColor(UIColor.blue, for: .normal)
        createButton?.addTarget(self, action: #selector(self.addButtonPressed), for: .touchUpInside)

        y += 100
        
        let bottomView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: y), size: CGSize(width: self.view.frame.width, height: self.view.frame.height - y)))
        bottomView.round(corners: [.topLeft, .topRight], radius: 10)
        bottomView.backgroundColor = UIColor.white
        
        titleLabel = UILabel(frame: CGRect(x: 0 , y: 0, width: 0, height: 0))
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.textAlignment = .center
        titleLabel?.text = toGame == true ? "SELECT DECK" : "DECKS"

        tableView = UITableView(frame: CGRect(x: 0, y: 100, width: bottomView.frame.width, height: bottomView.frame.height - 100))
        tableView?.register(DeckListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.separatorStyle = .none
        tableView?.rowHeight = 50.0
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        bottomView.addSubview(titleLabel!)
        bottomView.addSubview(backButton!)
        bottomView.addSubview(createButton!)
        bottomView.addSubview(tableView!)
        self.view.addSubview(bottomView)

        titleLabel?.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 25).isActive = true
        titleLabel?.leadingAnchor.constraint(equalTo: (backButton?.trailingAnchor)!, constant: 25).isActive = true
        titleLabel?.trailingAnchor.constraint(equalTo: (createButton?.leadingAnchor)!, constant: -25).isActive = true
        titleLabel?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @objc func cancelButtonPressed () {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonPressed () {
        let nextVC = CreateViewController()
        self.present(nextVC, animated: true, completion: nil)
    }
    
    // MARK: - Other Functions

    func loadJson(filename: String) -> ResponseData {
        
        // Get default
        if(filename == "Default") {
            if let url = Bundle.main.url(forResource: filename, withExtension: "json") {
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
        
        // Get Created Decks
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentsURL.appendingPathComponent(filename).appendingPathExtension("json")
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        } catch {
            print(error)
        }
        
        return ResponseData(Title: "", Cards: [])

    }
    
    func loadDeckNames () -> [String]
    {
        var tempArray: [String] = []
        tempArray.append("Default")
        
        // Get created Decks
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let docs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: [], options:  [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            let jsonFiles = docs.filter{ $0.pathExtension == "json" }
            print(jsonFiles.count)
            for file in jsonFiles
            {
                tempArray.append(file.absoluteURL.deletingPathExtension().lastPathComponent)
            }
        } catch {
            print(error)
        }
        
        return tempArray
    }

}

// MARK: - TableView Delegate

extension DeckListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! DeckListTableViewCell
        //cell.delegate = self
        cell.selectionStyle = .none
        cell.deckNameLabel?.text = decksNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(toGame) {
            // delay error, solution found here: https://stackoverflow.com/questions/21075540/presentviewcontrolleranimatedyes-view-will-not-appear-until-user-taps-again
            
            let nextVC = MainViewController()
            nextVC.ruleSet = loadJson(filename: decksNames[indexPath.row])
            DispatchQueue.main.async {
                self.present(nextVC, animated: true, completion: nil)
            }
            
        } else {
            
            let nextVC = CreateViewController()
            nextVC.ruleset = loadJson(filename: decksNames[indexPath.row])
            DispatchQueue.main.async {
                self.present(nextVC, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - TableView DataSource

extension DeckListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decksNames.count
    }
    
}
