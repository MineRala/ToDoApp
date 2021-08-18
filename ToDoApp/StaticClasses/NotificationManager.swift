//
//  NotificationManager.swift
//  ToDoApp
//
//  Created by Akmuhammet Ashyralyyev on 2021-08-17.
//

import UIKit

class NotificationManager {
    
    static let notificationCenter = UNUserNotificationCenter.current()
    
}

//MARK: - Create Notification
extension NotificationManager{
    static func createLocalNotification(title: String, body: String, date: Date, uuidString: String = UUID().uuidString){
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if error != nil {
                print("Error" + error.debugDescription)
                return
            }
            print("createLocalNotification is done.")
        }
    }
}

//MARK: - Remove Notification
extension NotificationManager{
    static func removeLocalNotification(notificationID: String) {
        
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [notificationID])
        print("removeDeliveredNotification is done.")
    }
}
