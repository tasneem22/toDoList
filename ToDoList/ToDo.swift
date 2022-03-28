//
//  ToDo.swift
//  ToDoList
//
//  Created by Tasneem Toolba on 24.03.2022.
//

import UIKit

struct ToDo: Equatable, Codable{
    let id : UUID
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    var link: String?
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        static let archiveURL = documentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
        
    
init(title: String, isComplete: Bool, dueDate: Date,
     notes: String?,link:String?) {
        self.id = UUID()
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
        self.link = link
    }
    static func saveToDos(_ toDos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(toDos)
        try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
    }
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool{
        return lhs.id == rhs.id
    }

        static func loadToDos() -> [ToDo]? {
            guard let codedToDos = try? Data(contentsOf: archiveURL) else { return nil }
            
            let propertyListDecoder = PropertyListDecoder()
            return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedToDos)
        }
    static func loadSampleToDos() -> [ToDo] {
        let toDo1 = ToDo(title: "To-Do One", isComplete: false,
           dueDate: Date(), notes: "Notes 1",link: "https://google.com")
        let toDo2 = ToDo(title: "To-Do Two", isComplete: false,
                         dueDate: Date(), notes: "Notes 2",link: "https://google.com")
        let toDo3 = ToDo(title: "To-Do Three", isComplete: false,
                         dueDate: Date(), notes: "Notes 3",link: "https://google.com")
        return [toDo1, toDo2, toDo3]
    }
    
}
