//
//  ToDoModel.swift
//  To Do
//
//  Created by Crislei Terassi Sorrilha on 1/30/18.
//  Copyright © 2018 Crislei Terassi Sorrilha. All rights reserved.
//

import Foundation

@objc(Task)
public class Task : NSObject, NSCoding{
    
    //MARK: Properties
    
    private var title: String!
    private var fullDescription: String!
    
    var taskTitle: String{
        get{
            return title
        }
        set{
            title = newValue
        }
    }
    
    var taskFullDescription: String{
        get{
            return fullDescription
        }
        set{
            fullDescription = newValue
        }
    }
    
    //MARK: Methods
    
    init(taskTitle: String, taskFullDescription: String) {
        title = taskTitle
        fullDescription = taskFullDescription
    }
    
    required convenience public init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let fullDescription = aDecoder.decodeObject(forKey: "fullDescription") as? String ?? ""
        self.init(taskTitle: title, taskFullDescription: fullDescription)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(fullDescription, forKey: "fullDescription")
    }
    
}
