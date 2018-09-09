//
//  ViewController.swift
//  SQLite test
//
//  Created by Andrew on 9/9/18.
//  Copyright © 2018 Andrii Halabuda. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {

    //MARK: Database poniter
    var db: OpaquePointer?
    
    //MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var powerTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Creating URL
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("HeroDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS Heroes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, Power INTEGER)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
            return
        }
        
        print("Database is up and running")
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let rank = powerTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (name?.isEmpty)! {
            print("Name is empty")
            return
        }
        
        if (rank?.isEmpty)! {
            print("Name is empty")
            return
        }
        
        var statement: OpaquePointer?
        
        let insertQuery = "INSERT INTO Heroes (name, power) VALUES (?, ?)"
        
        if sqlite3_prepare(db, insertQuery, -1, &statement, nil) != SQLITE_OK {
            print("Error binding query")
        }
        
        if sqlite3_bind_text(statement, 1, name, -1, nil) != SQLITE_OK {
            print("Error binding name")
        }
        
        if sqlite3_bind_int(statement, 2, (rank! as NSString).intValue) != SQLITE_OK {
            print("Error binding rank")
        }
        
        if sqlite3_step(statement) == SQLITE_DONE {
            print("Data Saved!")
        }
    }


}

