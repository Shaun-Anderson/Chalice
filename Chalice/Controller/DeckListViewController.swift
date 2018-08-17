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
    
    var decksNames: [String] = []
    var toGame : Bool = false
    
    var tableView: UITableView?
    var backButton: UIButton?
    var titleLabel : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        decksNames = loadDeckNames()
        
        var y = UIApplication.shared.statusBarFrame.height
        
        // Set back button
        backButton = UIButton(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        backButton?.backgroundColor = UIColor.red
        backButton?.addTarget(self, action: #selector(self.cancelButtonPressed), for: .touchUpInside)
        
        

        y += 100
        
        let bottomView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: y), size: CGSize(width: self.view.frame.width, height: self.view.frame.height - y)))
        bottomView.round(corners: [.topLeft, .topRight], radius: 10)
        bottomView.backgroundColor = UIColor.white
        
        titleLabel = UILabel(frame: CGRect(x: bottomView.center.x - 100 , y: 25, width: 200, height: 40))
        
        titleLabel?.text = toGame == true ? "Toplay" : "customise"

        tableView = UITableView(frame: CGRect(x: 0, y: 100, width: bottomView.frame.width, height: bottomView.frame.height - 100))
        tableView?.register(DeckListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.separatorStyle = .none
        tableView?.rowHeight = 50.0
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        bottomView.addSubview(titleLabel!)
        bottomView.addSubview(backButton!)
        bottomView.addSubview(tableView!)
        self.view.addSubview(bottomView)
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
            
            let nextVC = NewViewController()
            nextVC.ruleSet = loadJson(filename: decksNames[indexPath.row])
            self.present(nextVC, animated: true, completion: nil)
            
        } else {
            
            let nextVC = CreateViewController()
            print(decksNames[indexPath.row])
            nextVC.originalName = decksNames[indexPath.row]
            self.present(nextVC, animated: true, completion: nil)
            
        }
    }
}

// MARK: - TableView DataSource

extension DeckListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decksNames.count
    }
    
}
