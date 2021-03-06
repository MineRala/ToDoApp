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
    
    var selectedDate: Date?
    private var notificationTime: Int?
    
    private(set) var shouldDisplayAlertForInvalidNotification = CurrentValueSubject<[String:String], Never>([:])
    
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
            self.selectedDate = toDoItem?.taskDate
        }
        else{
            self.toDoItem = ToDoItem(context: ManagedObjectContext)
        }
    }
    
     func getMode() -> NewAndEditVCState {
        return pageMode
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
}

//MARK: - Create New Item
extension NewAndEditViewModel {
    func createNewItem(taskName: String?, taskDescription: String?, taskCategory: String?) -> Bool{
        
        if !isNotificationDateValid() {
            var dict: [String: String] = [:]
            dict["title"] = NSLocalizedString( "Invalid Notification Date", comment: "")
            dict["message"] = NSLocalizedString("If you press Continue, notification will not be set.", comment: "")
            dict["taskName"] = taskName
            dict["description"] = taskDescription
            dict["category"] = taskCategory
            shouldDisplayAlertForInvalidNotification.send(dict)
            return false
        }
        
        if taskName != nil && taskDescription != nil && taskCategory != nil  && selectedDate != nil {
            toDoItem.taskName = taskName
            toDoItem.taskDescription = taskDescription
            toDoItem.taskCategory = taskCategory
            toDoItem.taskDate = selectedDate
           

            if notificationTime == nil {
                if toDoItem.notificationID != "" {
                    self.removeNotification()
                }
                
            } else {
                toDoItem.notificationDate = selectedDate?.addingTimeInterval(-Double(notificationTime!))
                toDoItem.notificationID == "" ? self.createNotification() : updateNotification()
            }
            switch pageMode {
            case .newTask:
                toDoItem.isTaskCompleted = false
                toDoItem.taskId = UUID().uuidString
                coreDataLayer.create(toDoItem).sink { _ in}.store(in: &cancellables)
            case .editTask:
                coreDataLayer.update(toDoItem).sink { _ in}.store(in: &cancellables)
            }
            return true
        }
        return false
    }
    
    func isNotificationDateValid() -> Bool {
        if notificationTime == nil {
            return true
        }
        if selectedDate == nil {
            return true
        }
        return self.selectedDate!.addingTimeInterval(-Double(notificationTime!)) > Date()
    }
}

//MARK: - Set Notification
extension NewAndEditViewModel{
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
    
    func removeNotificationTime() {
        self.notificationTime = nil
    }
}

//MARK: - Get Notfication Title
extension NewAndEditViewModel{
    func getNotificationTitleAndRow(notificationDate fromDate: Date?, taskDate toDate: Date) -> (String, Int) {
        if fromDate == nil {
            return (NSLocalizedString("Do Not Send Notification", comment: ""), 0)
        }
        
        let timeDifferenceInSeconds = Int(toDate.timeIntervalSince(fromDate!))
        
        switch timeDifferenceInSeconds {
        case 5*60:
            return (NSLocalizedString("5 Minutes Before", comment: ""), 1)
        case 10*60:
            return (NSLocalizedString("10 Minutes Before", comment: ""), 2)
        case 15*60:
            return (NSLocalizedString("15 Minutes Before", comment: ""), 3)
        case 30*60:
            return (NSLocalizedString("30 Minutes Before", comment: ""), 4)
        case 1*60*60:
            return (NSLocalizedString("1 Hour Before", comment: ""), 5)
        case 2*60*60:
            return (NSLocalizedString("2 Hours Before", comment: ""), 6)
        case 5*60*60:
            return (NSLocalizedString("5 Hours Before", comment: ""), 7)
        case 24*60*60:
            return (NSLocalizedString("1 Day Before", comment: ""), 8)
        case 2*24*60*60:
            return (NSLocalizedString("2 Days Before", comment: ""), 9)
        default:
            return (NSLocalizedString("Do Not Send Notification", comment: ""), 0)
        }
    }
}

//MARK: - Specific Notification Function
extension NewAndEditViewModel{
    private func removeNotification() {
        NotificationManager.removeLocalNotification(notificationID: toDoItem.notificationID!)
        toDoItem.notificationDate = nil
        toDoItem.notificationID = ""
    }

    private func createNotification() {
        toDoItem.notificationID = UUID().uuidString
        pushNotification()
    }

    private func updateNotification() {
        NotificationManager.removeLocalNotification(notificationID: toDoItem.notificationID!)
        pushNotification()
    }
    func pushNotification() {
        toDoItem.notificationDate = selectedDate?.addingTimeInterval(-Double(notificationTime!))
        NotificationManager.createLocalNotification(title: toDoItem.taskName!, body: toDoItem.taskCategory!, date: toDoItem.notificationDate!, uuidString: toDoItem.notificationID!)
    }
}

