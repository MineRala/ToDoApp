//
//  EventTableViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 28.07.2021.
//

import Foundation
import UIKit
import Combine

class EventTableViewController : UIViewController {
  
    private var viewModel : HomeViewModel!
    var fetchDelegate: FetchDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    private let eventTableView : UITableView = {
        let etv = UITableView(frame: .zero,style: .plain)
        etv.translatesAutoresizingMaskIntoConstraints = false
        etv.allowsSelection = true
        etv.isUserInteractionEnabled = true
        return etv
    }()
    
    
    init(homeViewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = homeViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() }  // cancellabes ile hafızadan çıkardık
    }
}

//MARK: - Lifecycle
extension EventTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        addListeners()
    }
    
    func reloadData() {
        self.eventTableView.reloadData()
    }
}

//MARK: - Set Up UI
extension EventTableViewController {
    func setUpUI(){
        eventTableView.backgroundColor = C.BackgroundColor.clearColor
        self.view.addSubview(eventTableView)
        eventTableView.topAnchor(margin: 0)
            .leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .bottomAnchor(margin: 0)

        eventTableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        eventTableView.register(HeaderTaskCell.self, forCellReuseIdentifier: "HeaderTaskCell")
        eventTableView.dataSource = self
        eventTableView.delegate = self
        
        eventTableView.reloadData()
    }
}
// MARK: - TableView Delegate / Datasource
extension EventTableViewController: UITableViewDelegate, UITableViewDataSource, TaskCellDelegate {
    
    func taskCellDidSelected(_ cell: TaskCell, model: TaskListVDM) {
        let vc = TaskDetailsViewController(model: model.toDoItem)
        vc.delegate = self
        vc.fetchDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrAllElemetsEventTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type(of: viewModel.arrAllElemetsEventTableView[indexPath.row]) == TaskListVDMArrayElement.self {
            let cell = eventTableView.dequeueReusableCell(withIdentifier: "TaskCell",for: indexPath) as! TaskCell
            let taskListVDMArrayElement = (viewModel.arrAllElemetsEventTableView[indexPath.row] as? TaskListVDMArrayElement)!
            let model = taskListVDMArrayElement.taskListVDM
            cell.updateCell(model: model, delegate: self, index: taskListVDMArrayElement.indexAt)
            return cell
        } else {
            let headerCell = eventTableView.dequeueReusableCell(withIdentifier: "HeaderTaskCell", for: indexPath) as! HeaderTaskCell
            let currentElement = viewModel.arrAllElemetsEventTableView[indexPath.row] as! TaskListVDMHeaderArrayElement
            headerCell.updateHeaderCell(title: currentElement.getCellDateTitle() , date: currentElement.taskDate)
           return headerCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        if type(of:viewModel.arrAllElemetsEventTableView[indexPath.row]) == TaskListVDMHeaderArrayElement.self{
            return nil
        }
        
        let trash = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
            guard let self = self else {
                completionHandler(false)
                return
            }
            
            let index = (self.viewModel.arrAllElemetsEventTableView[indexPath.row] as! TaskListVDMArrayElement).indexAt
            self.handleTrash(toDoItem: self.viewModel.arrTaskListData[index].toDoItem)
            completionHandler(true)
        }
        trash.backgroundColor =  C.BackgroundColor.trashBackgroundColor
        trash.image = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 31)).image { _ in
            C.ImageIcon.trashIcon.draw(in: CGRect(x: 0, y: 0, width: 24, height: 24))
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if type(of:viewModel.arrAllElemetsEventTableView[indexPath.row]) == TaskListVDMHeaderArrayElement.self{
            return nil
        }
        
        let index = (self.viewModel.arrAllElemetsEventTableView[indexPath.row] as! TaskListVDMArrayElement).indexAt
        
        let done = UIContextualAction(style: .normal,title: nil) { [weak self] (action, view, completionHandler) in
            guard let self = self else{
                completionHandler(false)
                return
            }
       
            self.handleDone(toDoItem: self.viewModel.arrTaskListData[index].toDoItem)
            completionHandler(true)
        }
        done.backgroundColor = C.BackgroundColor.doneBackgroundColor
      
        if self.viewModel.arrTaskListData[index].isTaskCompleted {
            done.image = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 31)).image { _ in
                C.ImageIcon.undoIcon.draw(in: CGRect(x: 0, y: 0, width: 24, height: 24))
            }
        } else {
            done.image = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 31)).image { _ in
                C.ImageIcon.doneIcon.draw(in: CGRect(x: 0, y: 0, width: 24, height: 31))
            }
        }

        let configuration = UISwipeActionsConfiguration(actions: [done])
        return configuration
    }
}


// MARK: -  Task Cell Delete Delegate
extension EventTableViewController: TaskCellDeleteAndDoneDelegate {
 
    func taskCellDeleted(toDoItem: ToDoItem) {
        self.viewModel.removedElement(toDoItem: toDoItem)
        self.fetchDelegate?.fetchData()
    }
    
    func taskCellDoneTapped(toDoItem: ToDoItem) {
       handleDone(toDoItem: toDoItem)
    }
}

extension EventTableViewController: FetchDelegate {
    func fetchData() {
        self.fetchDelegate?.fetchData()
    }
}

//MARK: - Actions
extension EventTableViewController {
    private func handleTrash(toDoItem: ToDoItem) {
      print("Trash")
        Alerts.showAlertDelete(controller: self,NSLocalizedString("Are you sure you want to delete the task?", comment: ""), deletion: {
            self.viewModel.removedElement(toDoItem: toDoItem)
            self.fetchDelegate?.fetchData()
            self.viewModel.initializeArrAllElemetsEventTableView()
            self.eventTableView.reloadData()
        })
    }
    
    private func handleDone(toDoItem: ToDoItem){
        print("Done")
        self.viewModel.reverseTaskCompletionAtIndex(toDoItem: toDoItem)
        self.fetchDelegate?.fetchData()
    }
}

// MARK: - Listeners
extension EventTableViewController {
    private func addListeners() {
        viewModel.shouldUpdateAllData
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.viewModel.initializeArrAllElemetsEventTableView()
                self.eventTableView.reloadData()
                self.changeScrollOffset(to: self.viewModel.selectedDate ?? Date())
        
        }.store(in: &cancellables)
        
        viewModel.shouldUpdateAllDateWithFilter
            .receive(on: DispatchQueue.main)
            .sink { filterKeyword in
                self.viewModel.initializeArrAllElementsWithFilter(with: filterKeyword)
                self.eventTableView.reloadData()
                self.changeScrollOffset(to: self.viewModel.selectedDate ?? Date())
        
        }.store(in: &cancellables)
        
        viewModel.shouldChangeScrollOffsetOfEventsTable
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.changeScrollOffset(to: self.viewModel.selectedDate ?? Date())
        }.store(in: &cancellables)
    }
}

// MARK: - Scroll Offset Update
extension EventTableViewController {
    private func changeScrollOffset(to date: Date) {
//        var indexPath: IndexPath?
        let rowCount = self.tableView(eventTableView, numberOfRowsInSection: 0)
        for index in 0 ..< rowCount {
            if  let cell = self.tableView(eventTableView, cellForRowAt: IndexPath(row: index, section: 0)) as? HeaderTaskCell {
                if cell.date >= date {
                    let indexPath = IndexPath(row: index, section: 0)
                    eventTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    NSLog("Scrolling to Offset for selected Date: \(date.toString(with: "dd/MM"))")
                    return
                }
//                if cell.date.year == date.year && cell.date.month == date.month && cell.date.day == date.day {
//                    indexPath = IndexPath(row: index, section: 0)
//                }
            }
        }
//        if let indexPathCell = indexPath {
//            eventTableView.scrollToRow(at: indexPathCell , at: .top, animated: true)
//        }
//        NSLog("Scrolling to Offset for selected Date: \(date.toString(with: "dd/MM"))")
    }
}

