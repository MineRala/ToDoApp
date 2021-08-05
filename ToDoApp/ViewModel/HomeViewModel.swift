//
//  HomeViewModel.swift
//  ToDoApp
//
//  Created by Aybek Can Kaya on 27.07.2021.
//

import Foundation
import Combine

class HomeViewModel {
// update olduğunda combine ile mesaj yollasın.
    
    var arrTaskData: [TaskListVDM] = []

    private let dataLayer = CoreDataLayer()
    
    func initVM() {
        //getdataModelden çekince eşitleyip combine ile bildiricek
    }

    func getDataModels() -> [TaskListVDM]?{
    
        let dataItems = dataLayer.getAllItems()
        let vdms = dataItems.compactMap { (toDoItem) -> TaskListVDM? in
            return TaskVDMConverter.taskViewDataModel(toDoItem: toDoItem)
        }
        return vdms
    }
    
    
}
//var toDoItem = ToDoItem(context: dataLayer.context)
//        print("\(toDoItem.id)")
//        toDoItem.taskName = "Task1"
//        toDoItem.taskCategory = "Official"
//        toDoItem.taskDate = Date().addingTimeInterval(24*60*60*3)
//        toDoItem.taskId = UUID().uuidString
//        toDoItem.taskDescription = "Task Desc"
//        toDoItem.notificationDate = toDoItem.taskDate?.addingTimeInterval(-1*10*60)
//        toDoItem.isTaskCompleted = false
//        dataLayer.createItem(item: toDoItem)
//
//
//        toDoItem = ToDoItem(context: dataLayer.context)
//        print("\(toDoItem.id)")
//        toDoItem.taskName = "Task2"
//        toDoItem.taskCategory = "Official"
//        toDoItem.taskDate = Date().addingTimeInterval(24*60*60*6)
//        toDoItem.taskId = UUID().uuidString
//        toDoItem.taskDescription = "Task Desc2"
//        toDoItem.notificationDate = toDoItem.taskDate?.addingTimeInterval(-1*10*60)
//        toDoItem.isTaskCompleted = false
//        dataLayer.createItem(item: toDoItem)
//
//        toDoItem = ToDoItem(context: dataLayer.context)
//        print("\(toDoItem.id)")
//        toDoItem.taskName = "Task3"
//        toDoItem.taskCategory = "Official"
//        toDoItem.taskDate = Date().addingTimeInterval(24*60*60*10)
//        toDoItem.taskId = UUID().uuidString
//        toDoItem.taskDescription = "Task Desc3"
//        toDoItem.notificationDate = toDoItem.taskDate?.addingTimeInterval(-1*10*60)
//        toDoItem.isTaskCompleted = false
//        dataLayer.createItem(item: toDoItem)
//
//        toDoItem = ToDoItem(context: dataLayer.context)
//        print("\(toDoItem.id)")
//        toDoItem.taskName = "Task4"
//        toDoItem.taskCategory = "Official"
//        toDoItem.taskDate = Date().addingTimeInterval(24*60*60*15)
//        toDoItem.taskId = UUID().uuidString
//        toDoItem.taskDescription = "Task Desc4"
//        toDoItem.notificationDate = toDoItem.taskDate?.addingTimeInterval(-1*10*60)
//        toDoItem.isTaskCompleted = false
//        dataLayer.createItem(item: toDoItem)
