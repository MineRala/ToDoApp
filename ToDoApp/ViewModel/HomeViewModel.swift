//
//  HomeViewModel.swift
//  ToDoApp
//
//  Created by Aybek Can Kaya on 27.07.2021.
//

import Foundation
import Combine

class HomeViewModel {
    
    var isNeededToReloadData: Bool = false
    private let coreDataLayer = CoreDataLayer()
    private var arrAllTaskListData: [TaskListVDM] = []
    private var filterKeyword: String?
    private(set) var arrTaskListData: [TaskListVDM] = []
    private(set) var arrAllElemetsEventTableView : [TaskListEventTableViewItem] = []
    private(set) var arrTaskListDataFiltered = CurrentValueSubject<Array<TaskListVDM>,Never>([])
    private(set) var selectedDate: Date?
    private(set) var minimumVisibleDate: Date?
    private(set) var maximumVisibleDate: Date?
    
    private(set) var shouldUpdateAllData = PassthroughSubject<Void, Never>()
    private(set) var shouldChangeScrollOffsetOfEventsTable = PassthroughSubject<Void, Never>()
   
    private var cancellables = Set<AnyCancellable>()
    private(set) var earliestDayIndexRow: Int!
    
    init() {
        addListeners()
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
        let readTodosPublisher: AnyPublisher<CoreDataResponse<ToDoItem>, Never> = self.coreDataLayer.read(filterPredicate: nil)
        let taskListVDMsPublisher = readTodosPublisher.flatMap { response -> AnyPublisher<[TaskListVDM], Never> in
            guard self.showErrorIfNeeded(from: response) == false else {
                return Just([]).eraseToAnyPublisher()
            }
            return self.convertTodoItemsToVDMs(response.items)
        }.eraseToAnyPublisher()
        
        shouldUpdateAllData.send()
        
        taskListVDMsPublisher.sink { taskListVDMs in
            self.arrTaskListData = taskListVDMs
            self.arrTaskListDataFiltered.send(taskListVDMs)
            self.initializeArrAllElemetsEventTableView()
    //        self.initializeEarliestDate()
            
            self.shouldUpdateAllData.send()
        }.store(in: &cancellables)
    }

}

//MARK: - Initialize Array All Element
extension HomeViewModel {
    func initializeArrAllElemetsEventTableView() {
        if self.arrAllElemetsEventTableView.count > 0 {
            self.arrAllElemetsEventTableView.removeAll()
        }
        
        let arrFiltered = arrTaskListDataFiltered.value
        for index in 0 ..< arrFiltered.count {
            if index == 0 || arrFiltered[index-1].day != arrFiltered[index].day {
                let titleCell = TaskListVDMHeaderArrayElement(cellDateTitle: arrFiltered[index].day , date: arrFiltered[index].taskDate)
                self.arrAllElemetsEventTableView.append(titleCell)
                let taskCell = TaskListVDMArrayElement(taskListVDM: arrFiltered[index], indexAt: index)
                self.arrAllElemetsEventTableView.append(taskCell)
                continue
            }
            else {
                let taskCell = TaskListVDMArrayElement(taskListVDM: arrFiltered[index], indexAt: index)
                self.arrAllElemetsEventTableView.append(taskCell)
               
            }
        }
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
//MARK: - Listeners
extension HomeViewModel {
    private func addListeners() {
        self.arrTaskListDataFiltered
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.shouldUpdateAllData.send()
            }.store(in: &cancellables)
      //  self.initializeEarliestDate()
    }
}

// MARK: - Public
extension HomeViewModel {
    func removedElement(toDoItem: ToDoItem){
        coreDataLayer.remove(toDoItem).sink { _ in }.store(in: &cancellables)
    }

    func reverseTaskCompletionAtIndex(toDoItem: ToDoItem){
        toDoItem.isTaskCompleted = !toDoItem.isTaskCompleted
        coreDataLayer.update(toDoItem)
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

    func searchToDoItem(withNotificationID notificationID: String) -> ToDoItem? {
        for taskEditVDM in arrTaskListData {
            if taskEditVDM.toDoItem.notificationID != "" && taskEditVDM.toDoItem.notificationID == notificationID {
                return taskEditVDM.toDoItem
            }
        }
        return nil
    }
}
