//
//  ToDoItem+CoreDataProperties.swift
//  ToDoApp
//
//  Created by Mine Rala on 4.08.2021.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var taskName: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskCategory: String?
    @NSManaged public var taskDate: Date?
    @NSManaged public var notificationDate: Date?
    @NSManaged public var taskId: String?

}

extension ToDoItem : Identifiable {

}
