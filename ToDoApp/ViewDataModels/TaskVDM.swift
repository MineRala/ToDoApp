//
//  TaskVDM.swift
//  ToDoApp
//
//  Created by Mine Rala on 4.08.2021.
//

import Foundation

struct TaskListVDM: Hashable {
    let toDoItem: ToDoItem
    let taskName: String
    let taskCategory: String
    let dateHourAndMinute: String
    let datePeriod: String
    let taskId: String
    var isTaskCompleted: Bool
    let day: String
    let taskDate: Date 
}

struct TaskDetailVDM {
    let taskName: String
    let taskDescription: String
    let taskDate: String
    let taskId: String
    let isTaskCompleted: Bool
}

struct TaskEditVDM {
    var taskNameTitle: String
    var taskDescriptionTitle: String
    let taskCategoryTitle: String
    let taskDateTitle: String
    let notificationDateTitle: String
    let taskName: String
    let taskDescription: String
    let taskCategory: String
    let taskDate: Date
    let taskDateFormated: String
    let notificationDate: Date?
    let notificationID: String?
    let taskId: String
}
