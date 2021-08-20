//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by Mine Rala on 24.07.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
               UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (accepted, _) in
                   if !accepted {
                       print("Notification access denied.")
                   }
               }
               return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
   
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "ToDoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

//MARK: - Notification Center Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let notificationID = response.notification.request.identifier
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })  else {
            completionHandler()
            return
        }
        
        let navController = window.rootViewController as! UINavigationController
        
        guard let homeViewController = navController.viewControllers.first as? HomeViewController else {
            completionHandler()
            return
        }
        
        guard let currentViewController = navController.viewControllers.last as? TaskDetailsViewController else {
            // If the application is not in TaskDetailViewController
            homeViewController.updateHomeViewControllerType(.localNotification(value: notificationID))
            completionHandler()
            return
        }
        
        if currentViewController.detailModel.getToDoItem().notificationID != nil && currentViewController.detailModel.getToDoItem().notificationID == notificationID {
            // If user is already in the TaskDetailViewController that containts same toDoItem then do nothing
            completionHandler()
            return
        }
        
        // If the current view controller is TaskDetailViewController but displays different toDoItem
        homeViewController.updateHomeViewControllerType(.localNotification(value: notificationID))
        completionHandler()
    }
}

