//
//  TaskVDMConverters.swift
//  ToDoApp
//
//  Created by Mine Rala on 4.08.2021.
//

import Foundation

class TaskVDMConverter {
    
    static func taskViewDataModel(toDoItem: ToDoItem) -> TaskListVDM? {
        guard let taskName = toDoItem.taskName  else {
            return nil
        }
        
        var dayAndNight : String = ""
        var hourString : String = ""
        var minuteString : String = ""

        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: toDoItem.taskDate!)
        let minute = calendar.component(.minute, from: toDoItem.taskDate!)

        if hour == 0{
            hour = 12
            dayAndNight = "AM"
        }
        else if(hour > 12) {
            hour = hour-12
            dayAndNight = "PM"
        }
        else if hour == 12 {
            dayAndNight = "PM"
        }
        else {
            dayAndNight = "AM"
        }
        
        let dateHourAndMinute = String(format: "%02d:%02d", hour, minute)
        let taskCategory = "\(toDoItem.taskCategory)"
        let taskId = "\(toDoItem.taskId)"
        let isTaskCompleted = toDoItem.isTaskCompleted
        
        return TaskListVDM(taskName: taskName, taskCategory: taskCategory, dateHourAndMinute: dateHourAndMinute, datePeriod: dayAndNight, taskId: taskId, isTaskCompleted: isTaskCompleted)
    }
    
    static func detailTaskViewModel(toDoItem: ToDoItem) -> TaskDetailVDM? {
        guard let taskName = toDoItem.taskName else{
            return nil
        }
        let taskDescription = "\(toDoItem.taskDescription)"
        let taskDate = "\(toDoItem.taskDate?.description)"
        let taskId = "\(toDoItem.taskId)"
        let isTaskCompleted = toDoItem.isTaskCompleted
        return TaskDetailVDM(taskName: taskName, taskDescription: taskDescription, taskDate: taskDate, taskId: taskId, isTaskCompleted: isTaskCompleted)
    }
    
    static func editTaskViewModel(toDoItem: ToDoItem) -> TaskEditVDM? {
        guard let taskName = toDoItem.taskName else {
            return nil
        }
        let taskDescription = "\(toDoItem.taskDescription)"
        let taskDate = "\(toDoItem.taskDate?.description)"
        let notificationDate = "\(toDoItem.notificationDate?.description)"
        let taskId = "\(toDoItem.taskId)"
        
        return TaskEditVDM(taskName: taskName, taskDescription: taskDescription, taskDate: taskDate, notificationDate: notificationDate, taskId: taskId)
    }
}
