//
//  NewAndEditVCState.swift
//  ToDoApp
//
//  Created by Akmuhammet Ashyralyyev on 2021-08-02.
//

import UIKit

enum NewAndEditVCState {
    case newTask
    case editTask
    
    var navigationBarTitle: String {
        switch self {
        case .newTask:
            return NSLocalizedString("New Task", comment: "")
        case .editTask:
            return NSLocalizedString("Edit Task", comment: "")
        }
    }
    
    var confirmButtonTitle: String {
        switch self {
        case .newTask:
            return NSLocalizedString("Add", comment: "")
        case .editTask:
            return NSLocalizedString("Save", comment: "")
        }
    }

}
