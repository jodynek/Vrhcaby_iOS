//
//  DBManager.swift
//  Vrhcaby
//
//  Created by Petr Jodas on 28.04.17.
//  Copyright © 2017 Petr Jodas. All rights reserved.
//

import UIKit

class DBManager: NSObject {
  static let shared: DBManager = DBManager()
  let databaseFileName = "database.sqlite"
  var pathToDatabase: String!
  var database: FMDatabase!
  
  override init() {
    super.init()
    
    let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
    pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
  }
  
  
  func createDatabase() -> Bool {
    var created = false
    
    if !FileManager.default.fileExists(atPath: pathToDatabase) {
      database = FMDatabase(path: pathToDatabase!)
      
      if database != nil {
        // Open the database.
        if database.open() {
          let createMoviesTableQuery = "create table movies (movieID integer primary key autoincrement not null, title text not null, category text not null, year integer not null, movieURL text, coverURL text not null, watched bool not null default 0, likes integer not null)"
          
          created = database.executeUpdate(createMoviesTableQuery, withParameterDictionary: nil)
          if (!created) {
            print("Could not create table.")
          }
          
          // At the end close the database.
          database.close()
        }
        else {
          print("Could not open the database.")
        }
      }
    }
    return created
  }

  func openDatabase() -> Bool {
    if database == nil {
      if FileManager.default.fileExists(atPath: pathToDatabase) {
        database = FMDatabase(path: pathToDatabase)
      }
    }
    
    if database != nil {
      if database.open() {
        return true
      }
    }
    return false
  }
  
}
