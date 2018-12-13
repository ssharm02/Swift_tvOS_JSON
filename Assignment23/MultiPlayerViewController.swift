//
//  MultiPlayerViewController.swift
//  Assignment23
//
//  Created by Xcode User on 2018-11-28.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import UIKit

struct Player: Decodable {
    
    let Name : String
    let Address : String }


class MultiPlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var jsonData = [String: Any]()
    //the json file url
    var player = [Player]()
    var playerName = [String]()
    var playerScore = [String]()
    
    @IBOutlet weak var tableData: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
         tableData.dataSource = self
         tableData.delegate = self
        jsonParser()
        self.tableData.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Step 4 - create variables below for JSON parsing
    var dbData : [NSDictionary]?
    let myUrl = "https://sharsart.dev.fast.sheridanc.on.ca/iOS/sqlToJson.php" as String
    
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    // Step 5 - Create method below to do JSON parsing
    func jsonParser() {
        let jsonURL = "https://sharsart.dev.fast.sheridanc.on.ca/iOS/sqlToJson.php"
        let url = URL(string: jsonURL)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            do {
                self.player = try JSONDecoder().decode([Player].self, from: data!)
                
                for info in self.player {
                    
                    self.playerName.append(info.Name)
                    self.playerScore.append(info.Address)
                    
                    print("\(self.playerName) : \(self.playerScore)")
                    
                    self.tableData.reloadData()
                }
                
            }
                
            catch {
                print("Error is : \n\(error)")
            }
            }.resume()
        self.tableData.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playerScore.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        //cell.textLabel?.text = playerName[indexPath.row]
        cell.textLabel?.text = playerName[indexPath.row] + "      " + playerScore[indexPath.row]
        return cell

    }
    

}
