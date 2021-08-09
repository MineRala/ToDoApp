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

    init(cellDateTitle: String) {
        self.cellDateTitle = cellDateTitle
    }

    func getCellDateTitle() -> String{
        return cellDateTitle
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

