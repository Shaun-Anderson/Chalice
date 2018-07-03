//
//  CreateViewController.swift
//  Chalice
//
//  Created by Shaun Anderson on 30/6/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RuleCellDelegate {

    // MARK: - RuleCellDelegate Functions
    
    func nameEditingFinished(index: Int, name: String) {
        ruleset?.Cards[index].actionName = name
    }
    
    func descEditingFinished(index: Int, desc: String) {
        ruleset?.Cards[index].actionDescription = desc
    }
    
    
    // Mark: TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ruleset!.Cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! RuleCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.titleLabel.text = ruleset?.Cards[indexPath.row].rank
        cell.actionNameInput.text = ruleset?.Cards[indexPath.row].actionName
        cell.actionDescInput.text = ruleset?.Cards[indexPath.row].actionDescription
        cell.index = indexPath.row
        return cell
    }

    // Mark: - Variables
    var createButton: UIButton?
    var nameTextView: UITextField?
    var tableView: UITableView?
    var ruleset: ResponseData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // generate base
        ruleset = loadJson(filename: "Template")
        
        var y = UIApplication.shared.statusBarFrame.height
        
        nameTextView = UITextField(frame: CGRect(x: self.view.frame.width/2-100, y: y, width: 200, height: 50))
        nameTextView?.backgroundColor = UIColor.gray
        
        createButton = UIButton(frame: CGRect(x: 0, y: y, width: 100, height: 50))
        createButton?.titleLabel?.text = "Create"
        createButton?.backgroundColor = UIColor.green
        createButton?.addTarget(self, action: #selector(self.saveFile), for: .touchUpInside)

        y += 60
        
        tableView = UITableView(frame: CGRect(origin: CGPoint(x: 0, y: y), size: CGSize(width: self.view.frame.width, height: self.view.frame.height - 60)))
        tableView?.backgroundColor = UIColor.white
        tableView?.register(RuleCell.self, forCellReuseIdentifier: "cell")
        tableView?.separatorStyle = .none
        tableView?.rowHeight = 100.0
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        self.view.addSubview(tableView!)
        self.view.addSubview(createButton!)
        self.view.addSubview(nameTextView!)
        // Create
        //saveFile()
        //getUploadedFileSet(filename: "NEW")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: change to load ruleset instead of array of cards, should make it shorter.
    func loadJson(filename: String) -> ResponseData {
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
        return ResponseData(Title: "", Cards: [])
    }

    @objc func saveFile()
    {
        // Error Checking
        
        // Name Checking
        if(nameTextView?.text!.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            print("Name must be something")
            return
        }
        // Cell Checking
        var errorClean = true
        if let ruleset = ruleset {
            for index in 0...ruleset.Cards.count-1 {
                
                if(ruleset.Cards[index].actionName.trimmingCharacters(in: .whitespaces).isEmpty || ruleset.Cards[index].actionDescription.trimmingCharacters(in: .whitespaces).isEmpty )
                {
                    print("\(index) A cell was not completed")
                    errorClean = false
                }
            }
        }
        if(!errorClean)
        {
            // TODO: Display error message?
            return
        }
        
        // Set Values
        ruleset?.Title = (nameTextView?.text)!
        
        let encodedData = try? JSONEncoder().encode(ruleset)
        //let file: FileHandle? = FileHandle(forWritingAtPath: "\(jsonObject.Title).json")
        let fileManager = FileManager.default
        do{
            // TODO Check if exisitng.
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent((ruleset?.Title)!).appendingPathExtension("json")
            // Set the data we want to write
            do{
                try encodedData?.write(to: fileURL)
                print(fileURL)
            }
            catch {
                print("Writing Error")
            }
        }
        catch
        {
            // ERROR
        }
        

    }
    
    func getUploadedFileSet(filename:String) {
        let fileManager = FileManager.default
        do{
            // TODO Check if exisitng.
            let path = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = path.appendingPathComponent(filename).appendingPathExtension("json")
            // Set the data we want to write
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: fileURL.path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print(jsonResult)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        }
        catch
        {
            print("FILE ERROR")
        }
    }
}
