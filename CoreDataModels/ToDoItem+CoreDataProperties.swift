//
//  ToDoItem+CoreDataProperties.swift
//  ToDoApp
//
//  Created by Aybek Can Kaya on 6.08.2021.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var isTaskCompleted: Bool
    @NSManaged public var notificationDate: Date?
    @NSManaged public var taskCategory: String?
    @NSManaged public var taskDate: Date?
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskId: String?
    @NSManaged public var taskName: String?

}

extension ToDoItem : Identifiable {

}
