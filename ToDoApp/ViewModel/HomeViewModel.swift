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
    private(set) var selectedDate: Date?
    private(set) var minimumVisibleDate: Date?
    private(set) var maximumVisibleDate: Date?
    
    private(set) var shouldUpdateAllData = PassthroughSubject<Void, Never>()
    private(set) var shouldChangeScrollOffsetOfEventsTable = PassthroughSubject<Void, Never>()
    private(set) var shouldUpdateAllDateWithFilter = CurrentValueSubject<String?, Never>("")
    
    private var cancellables = Set<AnyCancellable>()
    private(set) var earliestDayIndexRow: Int!
    
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

        taskListVDMsPublisher.sink { taskListVDMs in
            self.arrTaskListData = taskListVDMs
            self.initializeArrAllElementsWithFilter(with: self.filterKeyword)
        }.store(in: &cancellables)
    }

}

//MARK: - Initialize Array All Element
extension HomeViewModel {
    func initializeArrAllElemetsEventTableView() {
        
        if self.arrAllElemetsEventTableView.count > 0 {
            self.arrAllElemetsEventTableView.removeAll()
        }
        
        for index in 0 ..< arrTaskListData.count {
            if index == 0 || self.arrTaskListData[index-1].day != self.arrTaskListData[index].day {
                // Append TitleCell
                let titleCell = TaskListVDMHeaderArrayElement(cellDateTitle: self.arrTaskListData[index].day , date: self.arrTaskListData[index].taskDate)
                self.arrAllElemetsEventTableView.append(titleCell)
                // Append TaskCell
                let taskCell = TaskListVDMArrayElement(taskListVDM: self.arrTaskListData[index], indexAt: index)
                self.arrAllElemetsEventTableView.append(taskCell)
                continue
            } else {
                // Append TaskCell
                let taskCell = TaskListVDMArrayElement(taskListVDM: self.arrTaskListData[index], indexAt: index)
                self.arrAllElemetsEventTableView.append(taskCell)
            }
        }
    }
    
    func initializeArrAllElementsWithFilter(with filterKeyword: String? = nil) {
        if self.arrAllElemetsEventTableView.count > 0 {
            self.arrAllElemetsEventTableView.removeAll()
        }

        guard let filterWord = filterKeyword, filterKeyword != "" else {
            if self.filterKeyword == nil {
                self.initializeArrAllElemetsEventTableView()
                return
            } else {
                self.initializeArrAllElementsWithFilter(with: self.filterKeyword)
                return
            }
        }
        
        self.filterKeyword = filterWord
        
        var indexOfLastAddedItem : Int = -1
        
        for (index, taskListVDM) in arrTaskListData.enumerated() {
            if taskListVDM.taskName.lowercased().contains(filterWord.lowercased()) {
                if self.arrAllElemetsEventTableView.count == 0 || self.arrTaskListData[indexOfLastAddedItem].day != self.arrTaskListData[index].day{
                    let titleCell = TaskListVDMHeaderArrayElement(cellDateTitle: self.arrTaskListData[index].day , date: self.arrTaskListData[index].taskDate)
                    self.arrAllElemetsEventTableView.append(titleCell)

                    let taskCell = TaskListVDMArrayElement(taskListVDM: self.arrTaskListData[index], indexAt: index)
                    self.arrAllElemetsEventTableView.append(taskCell)
        
                } else {
                    let taskCell = TaskListVDMArrayElement(taskListVDM: self.arrTaskListData[index], indexAt: index)
                    self.arrAllElemetsEventTableView.append(taskCell)
                }
                indexOfLastAddedItem = index
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
    
    func removeFilterKeyword() {
        self.filterKeyword = nil
    }
}
