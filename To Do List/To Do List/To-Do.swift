//
//  To-Do.swift
//  To Do List
//
//  Created by JAGmer J on 07/02/2026.
//

import Foundation

struct ToDo: Equatable, Codable
{
    let id: UUID
    var title: String
    var category: String
    var isCompleted: Bool
    var dueDate: Date
    var notes: String?
    
    static let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDir.appendingPathComponent("toDos").appendingPathExtension("plist")
    static let categoryArchiveURL = documentsDir.appendingPathComponent("toDoCategories").appendingPathExtension("plist")
    
    init(title: String, category: String, isCompleted: Bool, dueDate: Date, notes: String? = nil)
    {
        self.id = UUID()
        self.title = title
        self.category = category
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.notes = notes
    }
    
    static func == (lhs: ToDo, rhs: ToDo) -> Bool
    {
        return lhs.id == rhs.id
    }
    static func loadToDos() -> [ToDo]?
    {
        
        guard let codedToDos = try? Data(contentsOf: archiveURL) else {
            print("codedToDos variable is NULL")
            return nil
        }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedToDos)
    }
    static func loadSampleToDos() -> [ToDo]
    {
        let sampleCatgories =  loadSampleCategories()
        
        let toDo1 = ToDo(title: "To-Do one", category: sampleCatgories[0], isCompleted: false, dueDate: Date(), notes: "Note 1")
        let toDo2 = ToDo(title: "To-Do two", category: sampleCatgories[1], isCompleted: false, dueDate: Date(), notes: "Note 2")
        let toDo3 = ToDo(title: "To-Do three", category: sampleCatgories[2], isCompleted: true, dueDate: Date().addingTimeInterval(24*60*60), notes: "Note 3")
        let toDo4 = ToDo(title: "To-Do four", category: sampleCatgories[3], isCompleted: false, dueDate: Date().addingTimeInterval(48*60*60), notes: "Note 4")
        let toDo5 = ToDo(title: "To-Do five", category: sampleCatgories[0], isCompleted: false, dueDate: Date().addingTimeInterval(72*60*60), notes: "Note 5")
        let toDo6 = ToDo(title: "To-Do six", category: sampleCatgories[1], isCompleted: true, dueDate: Date().addingTimeInterval(23*60*60), notes: "Note 6")
        
        return [toDo1, toDo2, toDo3, toDo4, toDo5, toDo6]
    }
    static func saveToDos(_ toDos: [ToDo])
    {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(toDos)
        for cate in toDos{ print(cate.category) }
        
        try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
        print("To-Do.swift: Line 56\nTried to write to file (\(codedToDos, default: "NULL")) to \(archiveURL).")
    }
    
    static func loadSampleCategories() -> [String]
    {
        return ["Work", "Personal", "Hobby", "Lovely"]
    }
    
    static func loadCategories() -> [String]?
    {
       
        guard let codedCategories = try? Data(contentsOf: categoryArchiveURL) else {
            print("codedCategories variable is NULL")
            return nil
        }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([String].self, from: codedCategories)
    }
    
    static func saveCategories(_ categories: [String])
    {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(categories)
        try? codedToDos?.write(to: categoryArchiveURL, options: .noFileProtection)
        print("To-Do.swift: Function saveCategories\nTried to write to file (\(codedToDos, default: "NULL")) to \(categoryArchiveURL).")
        
    }
}
