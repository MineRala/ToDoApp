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
    var isTaskCompleted :  Bool = false
   
    
    static func all() -> [TaskModel] {
        
        var arrInfo: [TaskModel] = []
        var info: TaskModel
        
        for i in 0..<100 {
            info = TaskModel()
            info.hourLabel = "10:00"
            info.hourPeriodLabel = "AM"
            info.taskName = "Arkadaşlar ile Eskişehir'de asd buluşma.Arkadaşlar ile Eskişehir'de buluşma. "
            info.taskCatagory = "Official"
            arrInfo.append(info)
        }
        
        return arrInfo
    }
}
