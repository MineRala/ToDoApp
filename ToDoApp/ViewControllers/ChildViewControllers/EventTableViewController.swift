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
        eventTableView.dataSource = self
        eventTableView.delegate = self
        
        
        eventTableView.reloadData()
    }
}

// MARK: - Public
extension EventTableViewController{
   
}
// MARK: - TableView Delegate / Datasource
extension EventTableViewController: UITableViewDelegate, UITableViewDataSource, TaskCellDelegate {
    
    func taskCellDidSelected(_ cell: TaskCell, model: TaskListVDM) {
        let vc = TaskDetailsViewController(model: model, indexPath: cell.getIndexPath())
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrTaskListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "TaskCell",for: indexPath)as! TaskCell
        let model = viewModel.arrTaskListData[indexPath.row]
        cell.updateCell(model: model, delegate: self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trash = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
            guard let self = self else{
                completionHandler(false)
                return
            }
            self.handleTrash(indexPath: indexPath)
            completionHandler(true)
        }
        trash.backgroundColor = #colorLiteral(red: 1, green: 0.2571013272, blue: 0.3761356473, alpha: 1)
        trash.image = #imageLiteral(resourceName: "DeleteIcon")
        
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = UIContextualAction(style: .normal,title: nil) { [weak self] (action, view, completionHandler) in
            guard let self = self else{
                completionHandler(false)
                return
            }
            self.handleDone(indexPath: indexPath)
            completionHandler(true)
        }
        done.backgroundColor = #colorLiteral(red: 0.2980392157, green: 0.7960784314, blue: 0.2549019608, alpha: 1)
        
//        if arrModel[indexPath.row].isTaskCompleted {
//            done.image = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 31)).image { _ in
//                #imageLiteral(resourceName: "undo").draw(in: CGRect(x: 0, y: 0, width: 24, height: 24))
//            }
//        } else {
//            done.image = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 31)).image { _ in
//                #imageLiteral(resourceName: "DoneIcon").draw(in: CGRect(x: 0, y: 0, width: 24, height: 31))
//            }
//        }
//
        let configuration = UISwipeActionsConfiguration(actions: [done])
        return configuration
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}


// MARK: -  Task Cell Delete Delegate
extension EventTableViewController: TaskCellDeleteAndDoneDelegate {
    func taskCellDeleted( indexPath : IndexPath) {
        eventTableView.reloadData()
    }
    
    func taskCellDoneTapped(indexPath: IndexPath) {
       handleDone(indexPath: indexPath)
    }
    
}


//MARK: - Actions
extension EventTableViewController {
    private func handleTrash(indexPath: IndexPath) {
      print("Trash")
        Alerts.showAlertDelete(controller: self,NSLocalizedString("Are you sure you want to delete the task?", comment: ""), deletion: {
            self.eventTableView.reloadData()
        })
    }
    
    private func handleDone(indexPath: IndexPath){
        print("Done")
//        arrModel[indexPath.row].isTaskCompleted = !arrModel[indexPath.row].isTaskCompleted
        self.eventTableView.reloadData()
    }
}

// MARK: - Listeners
extension EventTableViewController {
    private func addListeners() {
        viewModel.shouldUpdateData
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.eventTableView.reloadData()
        }.store(in: &cancellables)
    }
}
