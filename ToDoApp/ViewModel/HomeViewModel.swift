//
//  HomeViewModel.swift
//  ToDoApp
//
//  Created by Aybek Can Kaya on 27.07.2021.
//

import Foundation
import Combine

class HomeViewModel {

    private(set) var shouldUpdateData = PassthroughSubject<Void, Never>()
    
    
    private(set) var arrTaskListData: [TaskListVDM] = []

    private let dataLayer = CoreDataLayer()
    
    private var cancellables = Set<AnyCancellable>()
    
}

// MARK: - Public
extension HomeViewModel {
    func initializeViewModel() {
        //addSampleData(count: 500)
        shouldUpdateData.send()
        let allItemsPublisher = self.dataLayer.getAllItems().flatMap { response -> AnyPublisher<[TaskListVDM], Never> in
            if let error = response.error {
                // TODO: Error
                return Just([]).eraseToAnyPublisher()
            } else if response.success == false {
                return Just([]).eraseToAnyPublisher()
            }
            let convertedModels = TaskVDMConverter.taskViewDataModels(from: response.items)
            return Just(convertedModels).eraseToAnyPublisher()
        }
        
        allItemsPublisher.sink { taskVDMs in
            self.arrTaskListData = taskVDMs
            self.shouldUpdateData.send()
        }.store(in: &cancellables)
    }
}

extension HomeViewModel {
    
    private func convertTaskVMsToDictionary(arr: [TaskListVDM]) ->  [String: [TaskListVDM]]? {
    
        var dictionary: [ String : [TaskListVDM] ]?
        
        for i in 0 ..< arr.count {
            if i == 0 {
                dictionary = [arr[i].day : [arr[i]]]
            continue
            }
            if arr[i-1].day == arr[i].day {
                var taskListVDMs = dictionary![arr[i].day]
                taskListVDMs!.append(arr[i])
                dictionary!.updateValue(taskListVDMs!, forKey: arr[i].day)
            } else {
                dictionary = [arr[i].day : [arr[i]]]
            }
        }
        return dictionary
    }
    
    private func addSampleData(count: Int) {
        for index in 0 ..< count {
            let rndTime = Int.random(in: (-10*60*60*24) ..< (10*60*60*24))
            let toDoItem = ToDoItem(context: CoreDataLayer.context)
            print("\(toDoItem.id)")
            
            toDoItem.taskName = randomString(of: Int.random(in: 3 ..< 50))
            toDoItem.taskCategory = "Official"
            toDoItem.taskDate = Date().addingTimeInterval(TimeInterval(rndTime))
            toDoItem.taskId = UUID().uuidString
            toDoItem.taskDescription = randomString(of: Int.random(in: 10 ..< 500))
            toDoItem.notificationDate = toDoItem.taskDate?.addingTimeInterval(-1*10*60)
            toDoItem.isTaskCompleted = false
            dataLayer.createItem(item: toDoItem).sink { _ in
                
            }.store(in: &cancellables)
        }
    }
    
    func randomString(of length: Int) -> String {
         let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
         var s = ""
         for _ in 0 ..< length {
             s.append(letters.randomElement()!)
         }
         return s
    }
}


//var toDoItem = ToDoItem(context: dataLayer.context)
//        print("\(toDoItem.id)")
//        toDoItem.taskName = "Task1"
//        toDoItem.taskCategory = "Official"
//        toDoItem.taskDate = Date().addingTimeInterval(24*60*60*3)
//        toDoItem.taskId = UUID().uuidString
//        toDoItem.taskDescription = "Task Desc"
//        toDoItem.notificationDate = toDoItem.taskDate?.addingTimeInterval(-1*10*60)
//        toDoItem.isTaskCompleted = false
//        dataLayer.createItem(item: toDoItem)
//
//
//        toDoItem = ToDoItem(context: dataLayer.context)
//        print("\(toDoItem.id)")
//        toDoItem.taskName = "Task2"
//        toDoItem.taskCategory = "Official"
//        toDoItem.taskDate = Date().addingTimeInterval(24*60*60*6)
//        toDoItem.taskId = UUID().uuidString
//        toDoItem.taskDescription = "Task Desc2"
//        toDoItem.notificationDate = toDoItem.taskDate?.addingTimeInterval(-1*10*60)
//        toDoItem.isTaskCompleted = false
//        dataLayer.createItem(item: toDoItem)
//
//        toDoItem = ToDoItem(context: dataLayer.context)
//        print("\(toDoItem.id)")
//        toDoItem.taskName = "Task3"
//        toDoItem.taskCategory = "Official"
//        toDoItem.taskDate = Date().addingTimeInterval(24*60*60*10)
//        toDoItem.taskId = UUID().uuidString
//        toDoItem.taskDescription = "Task Desc3"
//        toDoItem.notificationDate = toDoItem.taskDate?.addingTimeInterval(-1*10*60)
//        toDoItem.isTaskCompleted = false
//        dataLayer.createItem(item: toDoItem)
//
//        toDoItem = ToDoItem(context: dataLayer.context)
//        print("\(toDoItem.id)")
//        toDoItem.taskName = "Task4"
//        toDoItem.taskCategory = "Official"
//        toDoItem.taskDate = Date().addingTimeInterval(24*60*60*15)
//        toDoItem.taskId = UUID().uuidString
//        toDoItem.taskDescription = "Task Desc4"
//        toDoItem.notificationDate = toDoItem.taskDate?.addingTimeInterval(-1*10*60)
//        toDoItem.isTaskCompleted = false
//        dataLayer.createItem(item: toDoItem)
