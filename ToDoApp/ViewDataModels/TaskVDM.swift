//
//  TaskVDM.swift
//  ToDoApp
//
//  Created by Mine Rala on 4.08.2021.
//

import Foundation

struct TaskListVDM {
    let taskName: String
    let taskCategory: String
    let dateHourAndMinute: String
    let datePeriod: String
    let taskId: String
    let isTaskCompleted: Bool
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
    let taskName: String
    let taskDescription: String
    let taskDate: String
    let notificationDate: String
    let taskId: String
}

