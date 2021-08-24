//
//  HomeViewModel.swift
//  ToDoApp
//
//  Created by Aybek Can Kaya on 27.07.2021.
//

import Foundation
import Combine

enum SearchMode {
    case idle
    case searching
}

enum LoadingMode {
    case idle
    case loading
}

class HomeViewModel {
    
    var isNeededToReloadData: Bool = false
    private let coreDataLayer = CoreDataLayer()
    private var filterKeyword: String?
    
    private var dctAllTaskListData: [Date: [TaskListVDM]] = [:]
    private(set) var dctTaskListData: [Date: [TaskListVDM]] = [:]
   // private(set) var arrAllElemetsEventTableView : [TaskListEventTableViewItem] = []
    private(set) var selectedDate: Date?
    private(set) var minimumVisibleDate: Date?
    private(set) var maximumVisibleDate: Date?

    private(set) var currentLoadingMode = CurrentValueSubject<LoadingMode, Never>(.idle)
    private(set) var currentSearchMode = CurrentValueSubject<SearchMode, Never>(.idle)
    private(set) var shouldUpdateAllData = PassthroughSubject<Void, Never>()
   
    private(set) var shouldChangeScrollOffsetOfEventsTable = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        self.cancellables.forEach { $0.cancel() }  // cancellabes ile hafızadan çıkardık
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

//MARK: - Fetch Event Data
extension HomeViewModel {
    func fetchEventsData() {
        self.currentLoadingMode.send(LoadingMode.loading)
        let readTodosPublisher: AnyPublisher<CoreDataResponse<ToDoItem>, Never> = self.coreDataLayer.read(filterPredicate: nil)
        let taskListVDMsPublisher = readTodosPublisher.flatMap { response -> AnyPublisher<[TaskListVDM], Never> in
            guard self.showErrorIfNeeded(from: response) == false else { return Just([]).eraseToAnyPublisher() }
            return self.convertTodoItemsToVDMs(response.items)
        }.eraseToAnyPublisher()

        let initializerPublisher = taskListVDMsPublisher.flatMap { taskListVDMs -> AnyPublisher<[Date: [TaskListVDM]], Never> in
            return self.initializeArrAllElemetsEventTableView(allTaskListVDM: taskListVDMs)
        }.flatMap { dct -> AnyPublisher<[Date: [TaskListVDM]], Never> in
            return self.filterDictionary(with: self.filterKeyword, allElementsDct: dct)
        }
        
        initializerPublisher.sink { taskListVDMDct in
            self.dctTaskListData = taskListVDMDct
            self.shouldUpdateAllData.send()
            self.currentLoadingMode.send(LoadingMode.idle)
            self.shouldChangeScrollOffsetOfEventsTable.send()
            
           // self.addSampleData(count: 10000000)
        }.store(in: &cancellables)
    }
}

//MARK: - Initialize Array All Element
extension HomeViewModel {
    func findClosestDate(for date: Date, from arrDates: [Date]) -> Date? {
        var minDate: Date?
        var timeInterval: TimeInterval = TimeInterval(Int.max)
        for index in 0 ..< arrDates.count {
            let currentDate = arrDates[index]
            let diff = fabs(currentDate.timeIntervalSince1970 - date.timeIntervalSince1970)
            if diff < timeInterval {
                timeInterval = diff
                minDate = currentDate
            }
        }
        return minDate
    }
    
    func initializeArrAllElemetsEventTableView(allTaskListVDM: [TaskListVDM]) -> AnyPublisher<[Date: [TaskListVDM]], Never>  {
        return Future { promise in
            DispatchQueue.global(qos: .background).async {
                let dct: [Date: [TaskListVDM]] = Dictionary(grouping: allTaskListVDM) {
                    let day = Int($0.taskDate.day)
                    let month = Int($0.taskDate.month)
                    let year = Int($0.taskDate.year)
                    let date = Date(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
                    return date!
                }
                
                DispatchQueue.main.async {
                    self.dctAllTaskListData = dct
                    promise(.success(dct))
                }
            }
        }.eraseToAnyPublisher()
    }
}

// MARK: - Filter
extension HomeViewModel {
    private func filterDictionary(with filterKeyword: String?, allElementsDct: [Date: [TaskListVDM]]) -> AnyPublisher<[Date: [TaskListVDM]], Never> {
        guard let keyword = filterKeyword, keyword.count > 0 else {
            return Just(self.dctAllTaskListData).eraseToAnyPublisher()
        }
        
        return Future { promise in
            DispatchQueue.global(qos: .background).async {
                let keywordSearchable = keyword.lowercased()
                var dct: [Date: [TaskListVDM]] = [:]
                allElementsDct.forEach { (key, value) in
                    let filteredArr = value.filter { taskVDM -> Bool in
                        return taskVDM.taskName.lowercased().contains(keywordSearchable) || taskVDM.taskCategory.lowercased() == keywordSearchable
                    }
                    
                    if filteredArr.count > 0 {
                        dct[key] = filteredArr
                    }
                }
                DispatchQueue.main.async {
                    promise(.success(dct))
                }
            }
        }.eraseToAnyPublisher()
    }
}

//MARK: - Show Error
extension HomeViewModel {
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
}

//MARK: - Convert ToDoItem To VDMs
extension HomeViewModel {
    private func convertTodoItemsToVDMs(_ items: [ToDoItem]) -> AnyPublisher<[TaskListVDM], Never> {
        let itemsSorted = items.sorted { (itemA, itemB) -> Bool in
            return itemA.taskDate! < itemB.taskDate!
        }
        let vdmItems = TaskVDMConverter.taskViewDataModels(from: itemsSorted)
        return Just(vdmItems).eraseToAnyPublisher()
    }

    private func convertTodoItemsToEditVDMs(_ items: [ToDoItem]) -> AnyPublisher<[TaskEditVDM], Never> {
        let itemsSorted = items.sorted { (itemA, itemB) -> Bool in
            return itemA.taskDate! < itemB.taskDate!
        }
        let vdmItems = TaskVDMConverter.editTaskViewDataModels(from: itemsSorted)
        return Just(vdmItems).eraseToAnyPublisher()
    }

    private func convertTodoItemsToDetailVDMs(_ items: [ToDoItem]) -> AnyPublisher<[TaskDetailVDM], Never> {
       let itemsSorted = items.sorted { (itemA, itemB) -> Bool in
           return itemA.taskDate! < itemB.taskDate!
       }
        let vdmItems = TaskVDMConverter.detailTaskViewDataModels(from: itemsSorted)
       return Just(vdmItems).eraseToAnyPublisher()
    }
}

// MARK: - Public
extension HomeViewModel {
    func updateSearchEditingMode(_ mode: SearchMode) {
        self.currentSearchMode.send(mode)
    }
    
    func updateSearchKeyword(with text: String?) {
      //  self.currentLoadingMode.send(.loading)
        self.filterKeyword = text
        let filterPublisher = self.filterDictionary(with: self.filterKeyword, allElementsDct: dctAllTaskListData)
        filterPublisher.sink { dctTaskListDatas in
            self.dctTaskListData = dctTaskListDatas
            self.currentLoadingMode.send(.idle)
            self.shouldUpdateAllData.send()
        }.store(in: &cancellables)
    }
    
    func removedElement(toDoItem: ToDoItem){
        coreDataLayer.remove(toDoItem).sink { _ in }.store(in: &cancellables)
    }

    func reverseTaskCompletionAtIndex(toDoItem: ToDoItem){
        toDoItem.isTaskCompleted = !toDoItem.isTaskCompleted
        coreDataLayer.update(toDoItem)
    }

    func initializeViewModel() {
        selectDate(Date())
    }

    func updateSelectedDate(_ date: Date) {
        selectDate(date)
    }

    func updateVisibleDateRange(min: Date, max: Date) {
        self.setVisibleDateRange(min: min, max: max)
    }

    func searchToDoItem(withNotificationID notificationID: String) -> ToDoItem? {
        for value in self.dctTaskListData.values {
            for taskListVDM in value {
                if taskListVDM.toDoItem.notificationID != "" && taskListVDM.toDoItem.notificationID == notificationID {
                    return taskListVDM.toDoItem
                }
            }
        }
        
        return nil
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
    
    private func addSampleData(count: Int) {
        for index in 0 ..< count {
            let rndTime = Int.random(in: (-365*60*60*24) ..< (365*60*60*24))
            let toDoItem = ToDoItem(context: ManagedObjectContext)
            //print("\(toDoItem.id)")
        
            toDoItem.taskName = randomString(of: Int.random(in: 3 ..< 100))
            toDoItem.taskCategory = "Official"
            toDoItem.taskDate = Date().addingTimeInterval(TimeInterval(rndTime))
            toDoItem.taskId = UUID().uuidString
            toDoItem.taskDescription = randomString(of: Int.random(in: 10 ..< 1500))
            toDoItem.notificationDate = toDoItem.taskDate?.addingTimeInterval(-1*10*60)
            toDoItem.isTaskCompleted = false
            coreDataLayer.create(toDoItem).sink { _ in
                NSLog("Created: \(toDoItem.taskId)")
            }.store(in: &cancellables)
        }
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

