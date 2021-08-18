//
//  EventTableViewArrayElements.swift
//  ToDoApp
//
//  Created by Mine Rala on 9.08.2021.
//

import Foundation

protocol TaskListEventTableViewItem {}

struct TaskListVDMHeaderArrayElement: TaskListEventTableViewItem {
    private var cellDateTitle: String = ""
    private(set) var taskDate: Date

    init(cellDateTitle: String, date: Date) {
        self.cellDateTitle = cellDateTitle
        self.taskDate = date
    }

    func getCellDateTitle() -> String{
        return cellDateTitle
    }
    
    func checkIsSameDate(with date: Date) -> Bool{
        return true
    }
}

struct TaskListVDMArrayElement: TaskListEventTableViewItem {
    var taskListVDM: TaskListVDM
    var indexAt: Int
    
    init(taskListVDM: TaskListVDM, indexAt: Int) {
        self.taskListVDM = taskListVDM
        self.indexAt = indexAt
    }
}

