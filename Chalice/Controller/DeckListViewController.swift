//
//  DeckListViewController.swift
//  Chalice
//
//  Created by Shaun Anderson on 1/8/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

class DeckListViewController: UIViewController {

    var decksNames: [String] = []

    func loadDecks () -> [String]
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
    
    var tableView: UITableView?
    var backButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        decksNames = loadDecks()
        
        var y = UIApplication.shared.statusBarFrame.height
        // Set up top area
        backButton = UIButton(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        backButton?.backgroundColor = UIColor.red
        backButton?.addTarget(self, action: #selector(self.cancelButtonPressed), for: .touchUpInside)

        y += 100
        // Set up TableView
        tableView = UITableView(frame: CGRect(origin: CGPoint(x: 0, y: y), size: CGSize(width: self.view.frame.width, height: self.view.frame.height - y)))
        tableView?.register(DeckListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.separatorStyle = .none
        tableView?.rowHeight = 50.0
        tableView?.dataSource = self
        tableView?.delegate = self
        decksNames.append("+")

        
        self.view.addSubview(backButton!)
        self.view.addSubview(tableView!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func cancelButtonPressed () {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonPressed () {
        // TODO: Add functionality
        let nextVC = CreateViewController()
        self.present(nextVC, animated: true, completion: nil)
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
        let nextVC = CreateViewController()
        print(decksNames[indexPath.row])
        nextVC.originalName = decksNames[indexPath.row]
        self.present(nextVC, animated: true, completion: nil)
    }
    
}

// MARK: - TableView DataSource

extension DeckListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decksNames.count
    }
    
}
