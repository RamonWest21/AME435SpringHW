//
//  ToDO.swift
//  ToDoList
//
//  Created by student on 2/26/20.
//  Copyright © 2020 Ramon. All rights reserved.
//

import UIKit
import CoreLocation

struct ToDo: Codable {
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
    static func loadToDos() -> [ToDo]? {
        guard let codedTodos = try? Date(contentsOf:ArchiveURL) else { return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedTodos)
        
    }
    
    static func loadSampleToDos() -> [ToDo] {
        let todo1 = ToDo(title: "ToDo One", isComplete: false, dueDate: Date(), notes: "Notes 1")
        let todo2 = ToDo(title: "ToDo Two", isComplete: false, dueDate: Date(), notes: "Notes 2")
        let todo3 = ToDo(title: "ToDo Three", isComplete: false, dueDate: Date(), notes: "Notes 3")
        
        return [todo1, todo2, todo3]
    }
    
   
    
    static let dueDateFormatter: DataFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    static func saveTodos(_ todos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedTodos = try? PropertyListEncoder.encode(todos)
        try? codedTodos?.write(to:ArchiveURL, options: .noFileProtection)
    }
    
}



