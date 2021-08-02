//
//  Model.swift
//  ToDoApp
//
//  Created by Mine Rala on 30.07.2021.
//

import Foundation
import UIKit

class Model {
    
   
    var hourLabel: String = ""
    var hourPeriodLabel: String = ""
    var taskName: String = ""
    var taskCatagory: String = ""
    var isTaskCompleted :  Bool = false
   
    
    static func all() -> [Model] {
        
        var arrInfo: [Model] = []
        var info: Model
        
        for i in 0..<100 {
            info = Model()
            info.hourLabel = "10:00"
            info.hourPeriodLabel = "AM"
            info.taskName = "Arkadaşlar ile Eskişehir'de asd buluşma.Arkadaşlar ile Eskişehir'de buluşma. "
            info.taskCatagory = "Official"
            arrInfo.append(info)
        }
        
        return arrInfo
    }
}
