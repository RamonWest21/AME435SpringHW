//
//  TableViewController.swift
//  ToDoList
//
//  Created by student on 2/26/20.
//  Copyright © 2020 Ramon. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    var todos = [ToDo]()
    
    @IBAction func unwindToToDoList(seque: UIStoryboardSegue){
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier") else {
                fatalError("Could not dequeue a cell")
            }
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        }
        else {
            todos = ToDo.loadSampleToDos()
        }
        navigationItem.leftBarButtonItem = editButtonItem
    }
}
