//
//  NewAndEditVCState.swift
//  ToDoApp
//
//  Created by Akmuhammet Ashyralyyev on 2021-08-02.
//

enum NewAndEditVCState{
    case newTask
    case editTask
    
    var navigationBarTitle: String {
        switch self {
        case .newTask:
            return "New Task"
        case .editTask:
            return "Edit Task"
        }
    }
}
