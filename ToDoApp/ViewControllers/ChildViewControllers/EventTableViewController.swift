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
        eventTableView.register(HeaderTaskCell.self, forCellReuseIdentifier: "HeaderTaskCell")
        eventTableView.dataSource = self
        eventTableView.delegate = self
    
        eventTableView.reloadData()
    }
}
// MARK: - TableView Delegate / Datasource
extension EventTableViewController: UITableViewDelegate, UITableViewDataSource, TaskCellDelegate {
    
    func taskCellDidSelected(_ cell: TaskCell, model: TaskListVDM) {
        let vc = TaskDetailsViewController(model: model, indexPath: cell.getIndexPath())
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrAllElemetsEventTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type(of: viewModel.arrAllElemetsEventTableView[indexPath.row]) == TaskListVDM.self {
            let cell = eventTableView.dequeueReusableCell(withIdentifier: "TaskCell",for: indexPath)as! TaskCell
            let model = viewModel.arrAllElemetsEventTableView[indexPath.row]
            cell.updateCell(model: model as! TaskListVDM, delegate: self, indexPath: indexPath)
            return cell
        }else{
             let headerCell = eventTableView.dequeueReusableCell(withIdentifier: "HeaderTaskCell", for: indexPath)as! HeaderTaskCell
            headerCell.updateHeaderCell(title: ((viewModel.arrAllElemetsEventTableView[indexPath.row]as? TaskListVDMHeader)?.getCellDateTitle())!)
           return headerCell
        }
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
        self.viewModel.initializeArrAllElemetsEventTableView()
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
            self.viewModel.initializeArrAllElemetsEventTableView()
            self.eventTableView.reloadData()
          
        })
    }
    
    private func handleDone(indexPath: IndexPath){
        print("Done")
//        arrModel[indexPath.row].isTaskCompleted = !arrModel[indexPath.row].isTaskCompleted
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
