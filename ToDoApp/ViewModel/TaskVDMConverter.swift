//
//  TaskVDMConverters.swift
//  ToDoApp
//
//  Created by Mine Rala on 4.08.2021.
//

import Foundation

class TaskVDMConverter {
    
    static func taskViewDataModels(from toDoItems: [ToDoItem]) -> [TaskListVDM] {
        return toDoItems.compactMap { TaskVDMConverter.taskViewDataModel(toDoItem: $0) }
    }
   
    static func detailTaskViewDataModels(from toDoItems: [ToDoItem]) -> [TaskDetailVDM] {
        return toDoItems.compactMap {
            TaskVDMConverter.detailTaskViewModel(toDoItem: $0)
        }
    }
    
    static func editTaskViewDataModels(from toDoItems: [ToDoItem]) -> [TaskEditVDM] {
        return toDoItems.compactMap {
            TaskVDMConverter.editTaskViewModel(toDoItem: $0)
        }
    }
}

//MARK: - Format Converters
extension TaskVDMConverter {
    static func convertTo12HourPeriod(hour: Int) -> (Int, String) {
        if hour == 0 {
            return (12, "AM")
        }
        else if(hour > 12) {
            return (hour-12, "PM")
        }
        else if hour == 12 {
            return (hour, "PM")
        }
        else {
            return (hour, "AM")
        }
    }
    
    static func formatDateForTaskDetailVDM(date taskDate: Date) -> String {
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: taskDate)
        let minute = calendar.component(.minute, from: taskDate)
        let tupple12HourPeriod = convertTo12HourPeriod(hour: hour)
        
        hour = tupple12HourPeriod.0
        let dayAndNight = tupple12HourPeriod.1

        let dateHourAndMinute = String(format: "%02d:%02d %@", hour, minute, dayAndNight)
        
        let components = calendar.dateComponents([.year, .month, .day], from: taskDate)
        let monthName = DateFormatter().monthSymbols[components.month!-1]
        
        let index = monthName.index(monthName.startIndex, offsetBy: 3)
        let shortNameOfMonth = monthName.prefix(upTo: index)
        
        return String(format: "%02d %@, %04d | %@", components.day!, String(shortNameOfMonth), components.year!, dateHourAndMinute)
    }
    
    static func formatDateForEditTaskVDM(date taskDate: Date) -> String {
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: taskDate)
        let minute = calendar.component(.minute, from: taskDate)
        let tupple12HourPeriod = convertTo12HourPeriod(hour: hour)
        
        hour = tupple12HourPeriod.0
        let dayAndNight = tupple12HourPeriod.1
        
        let dateHourAndMınite = String(format: "%02d:%02d %@", hour,minute,dayAndNight)
        let  components = calendar.dateComponents([.year,.month,.day], from: taskDate)
        
        return String(format: "%02d-%02d-%04d | %@", components.day!,components.month!,components.year!,dateHourAndMınite)
    }
}

//MARK: - Task View Data Model Converter
extension TaskVDMConverter {
    static func taskViewDataModel(toDoItem: ToDoItem) -> TaskListVDM? {
        guard var taskName = toDoItem.taskName, let category = toDoItem.taskCategory, let taskDate = toDoItem.taskDate else { return nil }
        
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: taskDate)
        let minute = calendar.component(.minute, from: taskDate)
        let tupple12HourPeriod = convertTo12HourPeriod(hour: hour)

        var day: String = ""
        if calendar.isDateInToday(taskDate) {
            day = "Today"
        }
        else if calendar.isDateInYesterday(taskDate) {
            day = "Yesterday"
        }
        else if calendar.isDateInTomorrow(taskDate){
            day = "Tomorrow"
        }
        else {
            let components = calendar.dateComponents([.year, .month, .day], from: taskDate)
            let monthName = DateFormatter().monthSymbols[components.month!-1]
            day = String(format: "%02d %@", components.day!, monthName)
        }
        
        hour = tupple12HourPeriod.0
        let dayAndNight = tupple12HourPeriod.1
        
        let dateHourAndMinute = String(format: "%02d:%02d", hour, minute)
        
        let taskId = "\(toDoItem.taskId!)"
        let isTaskCompleted = toDoItem.isTaskCompleted
        
        return TaskListVDM(toDoItem: toDoItem,taskName: taskName, taskCategory: category, dateHourAndMinute: dateHourAndMinute, datePeriod: dayAndNight, taskId: taskId, isTaskCompleted: isTaskCompleted,day: day, taskDate: taskDate)
    }
}

//MARK: - Detail Task View Model Converter
extension TaskVDMConverter{
    static func detailTaskViewModel(toDoItem: ToDoItem) -> TaskDetailVDM? {
        guard let taskName = toDoItem.taskName, let taskDescription = toDoItem.taskDescription, let taskDate = toDoItem.taskDate else{
            return nil
        }
        let taskDateTime = formatDateForTaskDetailVDM(date: taskDate)
        let taskId = "\(toDoItem.taskId)"
        let isTaskCompleted = toDoItem.isTaskCompleted
        
        return TaskDetailVDM(taskName: taskName, taskDescription: taskDescription, taskDate: taskDateTime, taskId: taskId, isTaskCompleted: isTaskCompleted)
    }
    
    
}
    
//MARK: - Edit Task View Model Converter
    extension TaskVDMConverter {
    static func editTaskViewModel(toDoItem: ToDoItem) -> TaskEditVDM? {
        guard let taskName = toDoItem.taskName ,let taskDescription = toDoItem.taskDescription, let taskCategory = toDoItem.taskCategory, let taskDate = toDoItem.taskDate  else {
            return nil
        }
        
        var notificationDate : String? = nil
        
        if toDoItem.notificationDate != nil {
            notificationDate = toDoItem.notificationDate?.description
        }
        
        let taskNameTitle = NSLocalizedString("Task Name", comment: "")
        let taskDescriptionTitle = NSLocalizedString("Desciption", comment: "")
        let taskCategoryTitle = NSLocalizedString("Category", comment: "")
        let taskDateTitle  = NSLocalizedString("Pick Date & Time", comment: "")
        let notificationDateTitle = NSLocalizedString("Notification", comment: "")
        
        let taskDateTime = formatDateForEditTaskVDM(date: taskDate)
        let taskId = "\(toDoItem.taskId)"
        
        return TaskEditVDM(taskNameTitle: taskNameTitle, taskDescriptionTitle: taskDescriptionTitle, taskCategoryTitle: taskCategoryTitle, taskDateTitle: taskDateTitle, notificationDateTitle: notificationDateTitle, taskName: taskName, taskDescription: taskDescription, taskCategory: taskCategory, taskDate: taskDateTime, notificationDate: notificationDate, taskId: taskId)
    }
}
