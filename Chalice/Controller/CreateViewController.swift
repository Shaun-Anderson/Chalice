//
//  CreateViewController.swift
//  Chalice
//
//  Created by Shaun Anderson on 30/6/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RuleCellDelegate {

    // MARK: - Properties
    
    var originalName: String?
    
    // MARK: - RuleCellDelegate Functions
    
    func nameEditingFinished(index: Int, name: String) {
        ruleset?.Cards[index].actionName = name
    }
    
    func descEditingFinished(index: Int, desc: String) {
        ruleset?.Cards[index].actionDescription = desc
    }
    
    
    // Mark: TableView Delegate / DataSource
    
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
    var cancelButton: UIButton?
    var nameTextView: UITextField?
    var tableView: UITableView?
    var ruleset: ResponseData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // generate base
        ruleset = loadJson(filename: "Template")
        self.view.backgroundColor = UIColor(red: 14/255, green: 1/255, blue: 26/255, alpha: 1)

        var y = UIApplication.shared.statusBarFrame.height
        y += 40
        nameTextView = UITextField(frame: CGRect(x: self.view.frame.width/2-100, y: y, width: 200, height: 50))
        nameTextView?.attributedPlaceholder = NSAttributedString(string: "Deck Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        nameTextView?.textAlignment = .center
        print("awdkhawoidhawojdaw \(originalName)")

        if let name = originalName {
            nameTextView?.text = name
        }
        
        createButton = UIButton(frame: CGRect(x: self.view.frame.width-75, y: y, width: 50, height: 50))
        createButton?.setTitle("Create", for: .normal)
        createButton?.backgroundColor = UIColor.green
        createButton?.addTarget(self, action: #selector(self.saveFile), for: .touchUpInside)

        cancelButton = UIButton(frame: CGRect(x: 25, y: y, width: 50, height: 50))
        cancelButton?.setTitle("Cancel", for: .normal)
        cancelButton?.backgroundColor = UIColor.red
        cancelButton?.addTarget(self, action: #selector(self.cancelButtonPressed), for: .touchUpInside)
        
        y += 100
        
        tableView = UITableView(frame: CGRect(origin: CGPoint(x: 0, y: y), size: CGSize(width: self.view.frame.width, height: self.view.frame.height - y)))
        tableView?.register(RuleCell.self, forCellReuseIdentifier: "cell")
        tableView?.separatorStyle = .none
        tableView?.separatorColor = UIColor(red: 14/255, green: 1/255, blue: 26/255, alpha: 1)
        tableView?.rowHeight = 120.0
        tableView?.backgroundColor = UIColor.clear
        tableView?.dataSource = self
        tableView?.delegate = self
        
        self.view.addSubview(tableView!)
        self.view.addSubview(createButton!)
        self.view.addSubview(cancelButton!)
        self.view.addSubview(nameTextView!)
        
        nameTextView?.setBottomBorder(color: UIColor.white, size: 1)

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

    // TODO: add this to the background thread
    
    @objc func saveFile()
    {
        
        // Set Values
        ruleset?.Title = (nameTextView?.text)!
        
        // Check if data is valid/complete
        if (!dataIsValid()) { return }
        
        // Retrieve base url for document directory
        let fileManager = FileManager.default
        // Encode to JSON
        let encodedData = try? JSONEncoder().encode(ruleset)

        do {
            
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent((ruleset?.Title)!).appendingPathExtension("json")
            
            // If was editing an already create file just rename and change data.
            if let ogName = originalName {
                do {
                    var originPath = documentDirectory.appendingPathComponent("\(ogName).json")
                    let file = try FileHandle(forWritingTo: originPath)
                    // Set Data
                    file.write(encodedData!)
                    // Change Name
                    var resourceValues = URLResourceValues()
                    resourceValues.name = ruleset?.Title
                    try originPath.setResourceValues(resourceValues)
                    
                } catch {
                    print(error)
                }
            }
            
            // Check if file with title already exists.
            if fileManager.fileExists(atPath: fileURL.path) {
                
                // TODO: Create alert for overwrite.
                
            }
            else {
                
                // No file exists with name
                
                // If was editing an already existing file delete it
                
                do{
                    // TODO Check if exisitng.
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
            

            
        } catch {
            print(error)
        }
    }
    
    // MARK: - Actions
    
    @objc func cancelButtonPressed () {
        dismiss(animated: true, completion: nil)
    }
    
    func dataIsValid () -> Bool {
        
        // Title Check
        if(ruleset?.Title == nil)
        {
            return false
        }
        
        // Name Checking
        if(nameTextView?.text!.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            print("Name must be something")
            return false
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
            // TODO: Display error message for cell missing argument
            return false
        }
        
        return true
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
