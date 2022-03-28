//
//  ToDoDetailTableViewController.swift
//  ToDoList
//
//  Created by Tasneem Toolba on 25.03.2022.
//

import UIKit
import SafariServices

class ToDoDetailTableViewController: UITableViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var isCompleteButton: UIButton!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var dueDateDatePicker: UIDatePicker!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet var addLinkTextView: UITextView!
    
    @IBAction func openLinkButton(_ sender: Any) {
        if let link = addLinkTextView.text{
            if let url =
            URL(string: link){
                let safari =
                SFSafariViewController(url: url, entersReaderIfAvailable: false)

                safari.delegate = self as? SFSafariViewControllerDelegate
                        self.present(safari, animated: true, completion: {
                        })
            }
        }
    }
    
    var isDatePickerHidden = true
    var toDo : ToDo?
    let dateLabelIndexPath = IndexPath(row: 0, section: 1)
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesIndexPath = IndexPath(row: 0, section: 2)
    let linkIndexPath = IndexPath(row: 0, section: 3)
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDueDate: Date
        if let toDo = toDo {
          navigationItem.title = "To-Do"
          titleTextField.text = toDo.title
        
          isCompleteButton.isSelected = toDo.isComplete
          currentDueDate = toDo.dueDate
          notesTextView.text = toDo.notes
            addLinkTextView.text = toDo.link
        } else {
          currentDueDate = Date().addingTimeInterval(24*60*60)
        }
        dueDateDatePicker.date = currentDueDate
        updateDueDateLabel(date: currentDueDate)
        updateSaveButtonState()
    }
    
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = date.formatted(.dateTime.month(.defaultDigits)
           .day().year(.twoDigits).hour().minute())
    }
    func updateSaveButtonState() {
        let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }

    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }

    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected.toggle()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: sender.date)
    }
    override func tableView(_ tableView: UITableView,
       heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath where isDatePickerHidden == true:
            return 0
        case notesIndexPath:
            return 200
        case linkIndexPath:
            return 100
        default:
            return UITableView.automaticDimension
        }
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return 216
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == dateLabelIndexPath {
            isDatePickerHidden.toggle()
            updateDueDateLabel(date: dueDateDatePicker.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    
        guard segue.identifier == "saveUnwind" else { return }
    
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDateDatePicker.date
        let notes = notesTextView.text
        let link = addLinkTextView.text
        if toDo != nil {
                toDo?.title = title
                toDo?.isComplete = isComplete
                toDo?.dueDate = dueDate
                toDo?.notes = notes
            toDo?.link = link
            
            } else {
                toDo = ToDo(title: title, isComplete: isComplete,
                            dueDate: dueDate, notes: notes,link: link )
            }
    }
}
