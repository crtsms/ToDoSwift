//
//  ToDoTableViewController.swift
//  To Do
//
//  Created by Crislei Terassi Sorrilha on 2/28/18.
//  Copyright © 2018 Crislei Terassi Sorrilha. All rights reserved.
//

import UIKit
import os.log

class ToDoTableViewController: UITableViewController {

    //MARK: Properties
    var tasksItems = [TaskItem]()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets default margins for tableview
        tableView.layoutMargins = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        
        //Use the edit button provided bu the table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        //Load saved tasks
        if let savedTasks = loadTasks(){
            tasksItems = savedTasks
        }
        
        //Configure the default date formatter object
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ToDoTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ToDoTableViewCell else {
            fatalError("The dequeued cell is not an instance of ToDoTableViewCell")
        }
        //sets default margins for cell
        cell.layoutMargins = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        
        // Fetches the appropriate meal for the data source layout.
        let taskItem = tasksItems[indexPath.row]
        cell.dataLabel.text = dateFormatter.string(from: taskItem.date)
        cell.titleLabel.text = taskItem.title
        cell.descriptionLabel.text = taskItem.descriptionItem

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tasksItems.remove(at: indexPath.row)
            saveTasks()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new task.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let toDoDetailViewController = segue.destination as? ToDoViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedToDoCell = sender as? ToDoTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedToDoCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedTask = tasksItems[indexPath.row]
            toDoDetailViewController.taskItem = selectedTask
            
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToToDoList(sender: UIStoryboardSegue){
        
        if let sourceViewController = sender.source as? ToDoViewController, let taskItem = sourceViewController.taskItem {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                //Updating an existing taskItem
                tasksItems[selectedIndexPath.row] = taskItem
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                //Add a new taskItem
                let newIndexPath = IndexPath(row: tasksItems.count, section: 0)
                
                tasksItems.append(taskItem)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            //Save the tasks.
            saveTasks()
        }
        
    }
    
    //MARK: Private methods
    private func saveTasks(){
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasksItems, toFile: TaskItem.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Tasks successfully saved. ", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save tasks...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadTasks() -> [TaskItem]? {
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: TaskItem.ArchiveURL.path) as? [TaskItem]
        
    }

}
