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
    var delegateRetrieveTaskDetail: RetriveTaskEditVDMDelegate?
    var fetchDelegate: FetchDelegate?
  
    private let eventTableView : UITableView = {
        let etv = UITableView(frame: .zero,style: .plain)
        etv.translatesAutoresizingMaskIntoConstraints = false
        etv.allowsSelection = true
        etv.isUserInteractionEnabled = true
        return etv
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(homeViewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = homeViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Lifecycle
extension EventTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        addListeners()
        self.delegateRetrieveTaskDetail = self
    }
    
    func reloadData(){
        self.eventTableView.reloadData()
    }
}

//MARK: - Set Up UI
extension EventTableViewController {
    func setUpUI(){
        eventTableView.backgroundColor = .clear
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
        vc.delegateRetriveTaskEdit = self
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
            headerCell.updateHeaderCell(title: ((viewModel.arrAllElemetsEventTableView[indexPath.row]as? TaskListVDMHeaderArrayElement)?.getCellDateTitle())!)
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
            self.handleTrash(index: indexPath.row)
            completionHandler(true)
        }
        trash.backgroundColor = #colorLiteral(red: 1, green: 0.2571013272, blue: 0.3761356473, alpha: 1)
        trash.image = #imageLiteral(resourceName: "DeleteIcon")
        
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
            self.handleDone(index: index)
            completionHandler(true)
        }
        done.backgroundColor = #colorLiteral(red: 0.2980392157, green: 0.7960784314, blue: 0.2549019608, alpha: 1)
      
        if viewModel.arrTaskListData[index].isTaskCompleted{
            done.image = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 31)).image { _ in
                #imageLiteral(resourceName: "undo").draw(in: CGRect(x: 0, y: 0, width: 24, height: 24))
            }
        } else {
            done.image = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 31)).image { _ in
                #imageLiteral(resourceName: "DoneIcon").draw(in: CGRect(x: 0, y: 0, width: 24, height: 31))
            }
        }

        let configuration = UISwipeActionsConfiguration(actions: [done])
        return configuration
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}


// MARK: -  Task Cell Delete Delegate
extension EventTableViewController: TaskCellDeleteAndDoneDelegate {
    
    func taskCellDeleted(index: Int) {
        // Delete item with index from original array
        self.viewModel.removedElement(index: index)
        self.viewModel.initializeArrAllElemetsEventTableView()
        eventTableView.reloadData()
    }
    
    func taskCellDoneTapped(index: Int) {
        // Handle done in item at index index
       handleDone(index: index)
    }
}

//MARK: - Implentation of Protocols
extension EventTableViewController: RetriveTaskEditVDMDelegate {
    func getTaskEditVDM(index: Int) -> TaskEditVDM? {
        return self.delegateRetrieveTaskDetail?.getTaskEditVDM(index: index)
    }
}

extension EventTableViewController: FetchDelegate {
    func fetchData() {
        self.fetchDelegate?.fetchData()
    }
}

//MARK: - Actions
extension EventTableViewController {
    private func handleTrash(index: Int) {
      print("Trash")
        Alerts.showAlertDelete(controller: self,NSLocalizedString("Are you sure you want to delete the task?", comment: ""), deletion: {
            self.viewModel.removedElement(index: (self.viewModel.arrAllElemetsEventTableView[index] as? TaskListVDMArrayElement)!.indexAt)
            self.viewModel.initializeArrAllElemetsEventTableView()
            self.eventTableView.reloadData()
        })
    }
    
    private func handleDone(index: Int){
        print("Done")
        self.viewModel.reverseTaskCompletionAtIndex(index: index)
        self.viewModel.initializeArrAllElemetsEventTableView()
        self.eventTableView.reloadData()
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
        NSLog("Scrolling to Offset for selected Date: \(date.toString(with: "dd/MM"))")
    }
}

