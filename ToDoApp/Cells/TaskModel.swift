//
//  Model.swift
//  ToDoApp
//
//  Created by Mine Rala on 30.07.2021.
//

import Foundation
import UIKit

class TaskModel {
    var hourLabel: String = ""
    var hourPeriodLabel: String = ""
    var taskName: String = ""
    var taskCatagory: String = ""
    var isTaskCompleted: Bool = false
    
    static func all() -> [TaskModel] {
        
        var arrTaskInfo: [TaskModel] = []
        var taskInfo: TaskModel
        
        for _ in 0..<4 {
            taskInfo = TaskModel()
            taskInfo.hourLabel = "10:00"
            taskInfo.hourPeriodLabel = "AM"
            taskInfo.taskName = "Arkadaşlar ile Eskişehir'de asd buluşma.Arkadaşlar ile Eskişehir'de buluşma. "
            taskInfo.taskCatagory = "Official"
            arrTaskInfo.append(taskInfo)
        }
        
        return arrTaskInfo
    }
}
