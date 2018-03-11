//
//  ToDoViewController.swift
//  To Do
//
//  Created by Crislei Terassi Sorrilha on 3/2/18.
//  Copyright © 2018 Crislei Terassi Sorrilha. All rights reserved.
//

import UIKit
import os.log

class ToDoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    //This value is either passed by ToDoTableViewController in prepare(for:sender) or constructed as part of adding a neu task
    var taskItem: TaskItem?
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Handle the text field's user input through delegate callbacks
        titleTextField.delegate = self
        dateTextField.delegate = self
        descriptionTextView.delegate = self
        
        //Configure the default date formatter object
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //Add bar with button Done to datePicker control
        let tooBar = UIToolbar().ToolbarPiker(mySelect: #selector(self.dismissPicker))
        dateTextField.inputAccessoryView = tooBar
        
        //set up view if editing ans existing TaskItem
        if let taskItem = taskItem{
            
            navigationItem.title = taskItem.title
            titleTextField.text = taskItem.title
            dateTextField.text = dateFormatter.string(from: taskItem.date)
            descriptionTextView.text = taskItem.descriptionItem
            
        }
        
        //Enable the Save button only if the text field has a valid values
        updateSavedButtonState()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the Save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSavedButtonState()
        if textField.textInputContextIdentifier == "titleTextField" {
            navigationItem.title = textField.text
        }
    }
    
    //MARK: UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        //Disable the Save Button while editing
        //saveButton.isEnabled = false
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: Any){
        
        //Depending the style of presentation (modal or push presentation), this view
        //controller needs to be missed in two differents ways
        let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        
        if isPresentingInAddTaskMode {
            dismiss(animated: true, completion: nil)
        }else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }else{
            fatalError("The ToDoViewController is not inside a navigation controller")
        }
    }
    
    //This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        //Configure a destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let title = titleTextField.text ?? ""
        guard let date = dateFormatter.date(from: dateTextField.text!) else {
            fatalError("The date is not a valid date")
        }
        let description = descriptionTextView.text ?? ""
        
        //Set the meal to be passed to ToDoTableViewController after the unwind
        taskItem = TaskItem(title: title, date: date, descriptionItem: description)
        
    }
    
    //MARK: Actions
    @IBAction func dateTextTouchDown(_ sender: UITextField) {
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        
        //Check value of textField, If it doen't have value, call default value of datePicker
        if let currentDate = dateFormatter.date(from: dateTextField.text ?? ""){
            datePickerView.setDate(currentDate, animated: true)
        }
        
        //Calls the function to set default value of text field and add the action
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)

    }
    
    
    //MARK: Helper Methods
    @objc func handleDatePicker(sender: UIDatePicker) {
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    private func updateSavedButtonState(){
        
        //Disable the Save button if the text field is empty
        let title = titleTextField.text ?? ""
        let date = dateFormatter.date(from: dateTextField.text ?? "")
        let description = descriptionTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
        
        if title.isEmpty || date == nil || description == true {
            saveButton.isEnabled = false
        }else{
            saveButton.isEnabled = true
        }
        
    }
    

}
