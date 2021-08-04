//
//  TaskVDM.swift
//  ToDoApp
//
//  Created by Mine Rala on 4.08.2021.
//

import Foundation

struct TaskCellViewDataModel {
    let title: String
    let hourStr: String
    let category: String
    let amPmSymbol: String
}

struct NewTaskViewDataModel {
    let taskName: String
    let description: String
    let category: String
    let pickDateTime: String
    let notification: String
}

