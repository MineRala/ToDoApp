//
//  HomeViewModel.swift
//  ToDoApp
//
//  Created by Aybek Can Kaya on 27.07.2021.
//

import Foundation
import Combine

class HomeViewModel {
    
    private let coreDataLayer = CoreDataLayer()
    private(set) var arrTaskListData: [TaskListVDM] = []
    private(set) var arrAllElemetsEventTableView : [TaskListEventTableViewItem] = []
    private(set) var selectedDate: Date?
    private(set) var minimumVisibleDate: Date?
    private(set) var maximumVisibleDate: Date?
    
    private(set) var shouldUpdateAllData = PassthroughSubject<Void, Never>()
    private(set) var shouldChangeScrollOffsetOfEventsTable = PassthroughSubject<Void, Never>()
   
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - Public
extension HomeViewModel {
    
    func removedElement(index: Int){
        arrTaskListData.remove(at: index)
    }
    
    func reverseTaskCompletionAtIndex(index: Int){
       arrTaskListData[index].isTaskCompleted = !arrTaskListData[index].isTaskCompleted
    }
    
    func initializeViewModel() {
        //addSampleData(count: 500)
        selectDate(Date())
    }
    
    func updateSelectedDate(_ date: Date) {
        selectDate(date)
    }
    
    func updateVisibleDateRange(min: Date, max: Date) {
        self.setVisibleDateRange(min: min, max: max)
    }
}

// MARK: - Date Select
extension HomeViewModel {
    private func setVisibleDateRange(min: Date, max: Date) {
        self.minimumVisibleDate = min
        self.maximumVisibleDate = max
    }
    
    private func selectDate(_ date: Date) {
        if isNeededFetchEventsData() {
            self.fetchEventsData()
        }
        if isNeededChangeScrollOffset(for: date) {
            self.selectedDate = date
            self.shouldChangeScrollOffsetOfEventsTable.send()
        }
        self.selectedDate = date
    }
    
    fileprivate func isNeededChangeScrollOffset(for date: Date) -> Bool {
        guard let currentDate = selectedDate else { return true }
        if currentDate.day == date.day && currentDate.month == date.month && currentDate.year == date.year { return false }
        return true
    }
    
    fileprivate func isNeededFetchEventsData() -> Bool {
        return selectedDate == nil
    }
}

extension HomeViewModel {
    private func fetchEventsData() {
        let dateRangeFilter = ToDoItem.dateRangeFilterPredicate(minDate: Date(), maxDate: Date() + 1.years) // events that will occur in 24 hours
        let readTodosPublisher: AnyPublisher<CoreDataResponse<ToDoItem>, Never> = self.coreDataLayer.read(filterPredicate: dateRangeFilter)
        let taskListVDMsPublisher = readTodosPublisher.flatMap { response -> AnyPublisher<[TaskListVDM], Never> in
            guard self.showErrorIfNeeded(from: response) == false else {
                return Just([]).eraseToAnyPublisher()
            }
            return self.convertTodoItemsToVDMs(response.items)
        }.eraseToAnyPublisher()
        
        shouldUpdateAllData.send()
        
        taskListVDMsPublisher.sink { taskListVDMs in
            self.arrTaskListData = taskListVDMs
            
            self.initializeArrAllElemetsEventTableView()
            
            self.shouldUpdateAllData.send()
        }.store(in: &cancellables)
    }
    
    func initializeArrAllElemetsEventTableView() {
        if self.arrAllElemetsEventTableView.count > 0 {
            self.arrAllElemetsEventTableView.removeAll()
        }
        for index in 0 ..< self.arrTaskListData.count {
            if index == 0 || self.arrTaskListData[index-1].day != self.arrTaskListData[index].day {
                let titleCell = TaskListVDMHeaderArrayElement(cellDateTitle: self.arrTaskListData[index].day)
                self.arrAllElemetsEventTableView.append(titleCell)
                let taskCell = TaskListVDMArrayElement(taskListVDM: self.arrTaskListData[index], indexAt: index)
                self.arrAllElemetsEventTableView.append(taskCell)
                continue
            }
            else {
                let taskCell = TaskListVDMArrayElement(taskListVDM: self.arrTaskListData[index], indexAt: index)
                self.arrAllElemetsEventTableView.append(taskCell)
            }
        }
    }
    
     private func showErrorIfNeeded<T: CoreDataManagableObject>(from response: CoreDataResponse<T>) -> Bool {
        if let error = response.error {
           NSLog("Current Error :\(error)")
            return true
        } else if response.success == false {
            NSLog("unsuccessful")
            return true
        }
        return false
     }
    
     private func convertTodoItemsToVDMs(_ items: [ToDoItem]) -> AnyPublisher<[TaskListVDM], Never> {
        let itemsSorted = items.sorted { (itemA, itemB) -> Bool in
            return itemA.taskDate! < itemB.taskDate!
        }
        let vdmItems = TaskVDMConverter.taskViewDataModels(from: itemsSorted)
        return Just(vdmItems).eraseToAnyPublisher()
    }
}

extension HomeViewModel {
    func randomString(of length: Int) -> String {
         let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
         var s = ""
         for _ in 0 ..< length {
             s.append(letters.randomElement()!)
         }
         return s
    }
}

//
 // TODO
//private func addSampleData(count: Int) {
//    for index in 0 ..< count {
//        let rndTime = Int.random(in: (-10*60*60*24) ..< (10*60*60*24))
//        let toDoItem = ToDoItem(context: ManagedObjectContext)
//        print("\(toDoItem.id)")
//
//        toDoItem.taskName = randomString(of: Int.random(in: 3 ..< 50))
//        toDoItem.taskCategory = "Official"
//        toDoItem.taskDate = Date().addingTimeInterval(TimeInterval(rndTime))
//        toDoItem.taskId = UUID().uuidString
//        toDoItem.taskDescription = randomString(of: Int.random(in: 10 ..< 500))
//        toDoItem.notificationDate = toDoItem.taskDate?.addingTimeInterval(-1*10*60)
//        toDoItem.isTaskCompleted = false
//        coreDataLayer.create(toDoItem).sink { _ in
//
//        }.store(in: &cancellables)
//    }
//}

//var toDoItem = ToDoItem(context: dataLayer.context)
//        print("\(toDoItem.id)")
//        toDoItem.taskName = "Task1"
//        toDoItem.taskCategory = "Official"
//        toDoItem.taskDate = Date().addingTimeInterval(-24*60*60*3)
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
