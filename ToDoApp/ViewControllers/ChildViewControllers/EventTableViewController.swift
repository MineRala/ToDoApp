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
    
    private var sortedKeys: [Date] = []
    
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
        eventTableView.register(TaskHeaderView.self, forHeaderFooterViewReuseIdentifier: "TaskHeaderView")
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedKeys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentKey = sortedKeys[section]
        let arrTaskList = viewModel.dctTaskListData[currentKey] ?? []
        return arrTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "TaskCell",for: indexPath) as! TaskCell
        let currentKey = sortedKeys[indexPath.section]
        let arrTaskList = viewModel.dctTaskListData[currentKey] ?? []
        if indexPath.row < arrTaskList.count {
            let taskVDM =  arrTaskList[indexPath.row]
            cell.updateCell(model: taskVDM , delegate: self)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currentKey = sortedKeys[section]
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TaskHeaderView") as! TaskHeaderView
        headerView.updateHeaderCell(title: currentKey.toString(with: "dd/MM/yyyy"), date: currentKey)
      //  headerView.isUserInteractionEnabled = false
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let trash = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
            guard let self = self else {
                completionHandler(false)
                return
            }
            let currentKey = Array(self.viewModel.dctTaskListData.keys)[indexPath.section]
            let arrTaskList = self.viewModel.dctTaskListData[currentKey] ?? []
            let taskVDM = arrTaskList[indexPath.row]
            self.handleTrash(toDoItem: taskVDM.toDoItem)
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
        let currentKey = Array(self.viewModel.dctTaskListData.keys)[indexPath.section]
        let arrTaskList = self.viewModel.dctTaskListData[currentKey] ?? []
        let taskVDM = arrTaskList[indexPath.row]
        
        let done = UIContextualAction(style: .normal,title: nil) { [weak self] (action, view, completionHandler) in
            guard let self = self else {
                completionHandler(false)
                return
            }
            self.handleDone(toDoItem: taskVDM.toDoItem)
            completionHandler(true)
        }
        done.backgroundColor = C.BackgroundColor.doneBackgroundColor

        if taskVDM.isTaskCompleted {
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
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo }
            .receive(on: DispatchQueue.main)
            .sink { userInfo in
                guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
                let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
                self.eventTableView.contentInset = contentInsets
                self.eventTableView.scrollIndicatorInsets = contentInsets
            }.store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .compactMap { $0.userInfo }
            .receive(on: DispatchQueue.main)
            .sink { userInfo in
                self.eventTableView.contentInset = .zero
                self.eventTableView.scrollIndicatorInsets = .zero
        }.store(in: &cancellables)
        
        viewModel.shouldUpdateAllData
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.sortedKeys = self.viewModel.dctTaskListData.map { $0.key }.sorted()
                self.eventTableView.reloadData()
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
        guard let closestDate = viewModel.findClosestDate(for: date, from: self.sortedKeys) else { return }
        guard let index = sortedKeys.firstIndex(of: closestDate) else { return }
        let indexPath = IndexPath(row: 0, section: Int(index))
        eventTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
}

