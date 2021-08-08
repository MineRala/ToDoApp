//
//  ToDoItem+CoreDataProperties.swift
//  ToDoApp
//
//  Created by Aybek Can Kaya on 6.08.2021.
//
//

import Foundation
import CoreData


extension ToDoItem: CoreDataManagableObject {
    static var tableName: String { return "ToDoItem" }
    
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
//        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
//    }

    @NSManaged public var isTaskCompleted: Bool
    @NSManaged public var notificationDate: Date?
    @NSManaged public var taskCategory: String?
    @NSManaged public var taskDate: Date?
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskId: String?
    @NSManaged public var taskName: String?

    static func dateRangeFilterPredicate(minDate: Date, maxDate: Date) -> NSPredicate {
        let dateMinPredicate = NSPredicate(format: "%K > %@", #keyPath(ToDoItem.taskDate), (minDate as NSDate) )
        let dateMaxPredicate = NSPredicate(format: "%K < %@", #keyPath(ToDoItem.taskDate), (maxDate as NSDate) )
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dateMinPredicate, dateMaxPredicate])
        return datePredicate
    }
    
    static func newItem(taskTitle: String, taskDescription: String, taskCategory: String, taskDate: Date, notificationDate: Date? ) -> ToDoItem {
        let todoItem = ToDoItem(context: ManagedObjectContext)
        todoItem.taskId = UUID().uuidString
        todoItem.taskName = taskTitle
        todoItem.taskDescription = taskDescription
        todoItem.taskCategory = taskCategory
        todoItem.taskDate = taskDate
        todoItem.notificationDate = notificationDate
        todoItem.isTaskCompleted = false
        return todoItem
    }
    
    
}

extension ToDoItem : Identifiable {

}
