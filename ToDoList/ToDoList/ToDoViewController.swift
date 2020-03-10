//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by student on 3/10/20.
//  Copyright © 2020 Ramon. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var isPickerHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dueDatePickerView.date = Date().addingTimeInterval(24*60*60)
        updateDueDateLabel(date: dueDatePickerView.date)
        updateSaveButtonState()
        
    }
    // dynamic cell height for Date picker
    override func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)

        switch(indexPath){
            
        case [1, 0]: // Due Date cell
            return isPickerHidden ? normalCellHeight:
            largeCellHeight

        case [2,0]: // Notes Cell
            return largeCellHeight

        default: return normalCellHeight
        }
    }
    // dynamic cell height for Notes
    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath){
        
        switch(indexPath){

        case [1,0]:
            isPickerHidden = !isPickerHidden

            dueDateLabel.textColor = isPickerHidden ? .black : tableView.tintColor

            tableView.beginUpdates()
            tableView.endUpdates()

        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // page 755
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    
    func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }
}
