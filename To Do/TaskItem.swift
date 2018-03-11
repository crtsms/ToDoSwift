//
//  File.swift
//  To Do
//
//  Created by Crislei Terassi Sorrilha on 3/4/18.
//  Copyright © 2018 Crislei Terassi Sorrilha. All rights reserved.
//

import UIKit
import os.log

class TaskItem: NSObject, NSCoding{
    
    //MARK: Properties
    var title: String
    var date: Date
    var descriptionItem: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todo")
    
    //MARK: types
    struct PropertyKey{
        
        static let title = "title"
        static let date = "date"
        static let descriptionItem = "descriptionItem"
        
    }
    
    //MARK: Initialization
    init?(title: String, date: Date, descriptionItem: String) {
        
        //The name must be not empty
        guard !title.isEmpty else{
            return nil
        }
        
        //The description must be not empty
        guard !descriptionItem.isEmpty else{
            return nil
        }
        
        //Initialize stored properties.
        self.title = title
        self.date = date
        self.descriptionItem = descriptionItem
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(descriptionItem, forKey: PropertyKey.descriptionItem)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        //The name is required. If we not decode a name string, the initializer should fail
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the name for a Task object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        //The date is required. If we not decode a date, the initializer should fail
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else {
            os_log("Unable to decode the date for a Task object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        //The description is required. If we not decode a description string, the initializer should fail
        guard let descriptionItem = aDecoder.decodeObject(forKey: PropertyKey.descriptionItem) as? String else {
            os_log("Unable to decode the description for a Task object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        //Must call designated initializer
        self.init(title: title, date: date, descriptionItem: descriptionItem)
    }
    
}
