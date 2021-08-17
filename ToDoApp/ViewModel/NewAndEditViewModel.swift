//
//  NewTaskViewModel.swift
//  ToDoApp
//
//  Created by Mine Rala on 12.08.2021.
//

import Foundation
import Combine

class NewAndEditViewModel{
    
    private let coreDataLayer = CoreDataLayer()
    let toDoItem: ToDoItem!
    private(set) var editTaskVDM: TaskEditVDM?
    private var pageMode: NewAndEditVCState = .newTask
    var pickerDate: Date?
    private var notificationTime: Int?
    private var cancellables = Set<AnyCancellable>()
    
    let arrNotificationTime = [NSLocalizedString("Do Not Send Notification", comment: ""),
                               NSLocalizedString("5 Minutes Before", comment: ""),
                               NSLocalizedString("10 Minutes Before", comment: ""),
                               NSLocalizedString("15 Minutes Before", comment: ""),
                               NSLocalizedString("30 Minutes Before", comment: ""),
                               NSLocalizedString("1 Hour Before", comment: ""),
                               NSLocalizedString("2 Hours Before", comment: ""),
                               NSLocalizedString("5 Hours Before", comment: ""),
                               NSLocalizedString("1 Day Before", comment: ""),
                               NSLocalizedString("2 Days Before", comment: "")]
    
    init(toDoItem: ToDoItem? = nil) {
        if toDoItem != nil {
            self.toDoItem = toDoItem!
            self.editTaskVDM = TaskVDMConverter.editTaskViewModel(toDoItem: toDoItem!)
            self.pageMode = .editTask
            self.pickerDate = toDoItem?.taskDate
        }
        else{
            self.toDoItem = ToDoItem(context: ManagedObjectContext)
        }
    }
    
     func getMode() -> NewAndEditVCState {
        return pageMode
    }
    
   
    
    func createNewItem(taskName: String?, taskDescription: String?, taskCategory: String?){
        if taskName != nil && taskDescription != nil && taskCategory != nil  && pickerDate != nil {
            toDoItem.taskName = taskName
            toDoItem.taskDescription = taskDescription
            toDoItem.taskCategory = taskCategory
            toDoItem.taskDate = pickerDate
           
            if notificationTime == nil {
                if toDoItem.notificationID != "" && self.pickerDate == nil {
                                                            // if there is a notification in CoreData, then it
                                                            // should delete notification
                    // deleteNotification
                    NotificationManager.removeLocalNotification(notificationID: toDoItem.notificationID!)
                    toDoItem.notificationDate = nil
                    toDoItem.notificationID = ""
                } else if toDoItem.notificationID == "" && self.pickerDate != nil {
                                                            // If there is a notifiaction in CoreData and date has been
                                                            // changed, then notification should changed as well.
                    // createNotification
                    toDoItem.notificationID = UUID().uuidString
                    NotificationManager.createLocalNotification(title: toDoItem.taskName!, body: toDoItem.taskDate!.description, date: toDoItem.notificationDate!, uuidString: toDoItem.notificationID!)
                } else if toDoItem.notificationID != "" && self.pickerDate != nil {
                    // updateNotification
                    NotificationManager.removeLocalNotification(notificationID: toDoItem.notificationID!)
                    NotificationManager.createLocalNotification(title: toDoItem.taskName!, body: toDoItem.taskDate!.description, date: toDoItem.notificationDate!, uuidString: toDoItem.notificationID!)
                }
                
            } else {
                toDoItem.notificationDate = pickerDate?.addingTimeInterval(-Double(notificationTime!))
                // Check CoreData whether there is an existing Notification
                if toDoItem.notificationID != "" {
                    // deleteNotification
                    NotificationManager.removeLocalNotification(notificationID: toDoItem.notificationID!)
                } else {
                    toDoItem.notificationID = UUID().uuidString
                }
                // createNotification
                NotificationManager.createLocalNotification(title: toDoItem.taskName!, body: toDoItem.taskDate!.description, date: toDoItem.notificationDate!, uuidString: toDoItem.notificationID!)
                
            }
            switch pageMode {
            case .newTask:
                toDoItem.isTaskCompleted = false
                toDoItem.taskId = UUID().uuidString
                coreDataLayer.create(toDoItem).sink { _ in}.store(in: &cancellables)
                
            case .editTask:
                coreDataLayer.update(toDoItem).sink { _ in}.store(in: &cancellables)
            }
        }
    }
    
    func setNotificationTime(notificationTime: String) {
        switch notificationTime {
        case NSLocalizedString( "5 Minutes Before", comment: ""):
            self.notificationTime = 5*60
        case NSLocalizedString("10 Minutes Before", comment: ""):
            self.notificationTime = 10*60
        case NSLocalizedString("15 Minutes Before", comment: ""):
            self.notificationTime = 15*60
        case NSLocalizedString("30 Minutes Before", comment: ""):
            self.notificationTime = 30*60
        case NSLocalizedString("1 Hour Before", comment: ""):
            self.notificationTime = 1*60*60
        case NSLocalizedString("2 Hours Before", comment: ""):
            self.notificationTime = 2*60*60
        case NSLocalizedString("5 Hours Before", comment: ""):
            self.notificationTime = 5*60*60
        case NSLocalizedString("1 Day Before", comment: ""):
            self.notificationTime = 24*60*60
        case NSLocalizedString("2 Days Before", comment: ""):
            self.notificationTime = 2*24*60*60
        default:
            self.notificationTime = nil
        }
    }
}
