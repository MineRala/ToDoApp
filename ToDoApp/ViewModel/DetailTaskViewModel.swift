//
//  DetailTaskViewModel.swift
//  ToDoApp
//
//  Created by Mine Rala on 12.08.2021.
//

import Foundation

class DetailTaskViewModel {
    
    private let coreDataLayer = CoreDataLayer()
    private let toDoItem: ToDoItem!
    private(set) var detailTaskVDM: TaskDetailVDM?
    
    init(toDoItem: ToDoItem) {
        self.toDoItem = toDoItem
        self.detailTaskVDM = TaskVDMConverter.detailTaskViewModel(toDoItem: toDoItem)
    }
    
    func getToDoItem() -> ToDoItem{
        return toDoItem
    }
    
    func updateDetailTaskVDM() {
        self.detailTaskVDM = TaskVDMConverter.detailTaskViewModel(toDoItem: toDoItem)
    }
}
