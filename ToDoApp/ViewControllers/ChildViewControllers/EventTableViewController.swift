//
//  EventTableViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 28.07.2021.
//

import Foundation
import UIKit

class EventTableViewController : UIViewController{

    private var arrModel: [Model] = []
    
    
    private let eventTableView : UITableView = {
        let etv = UITableView(frame: .zero,style: .plain)
        etv.translatesAutoresizingMaskIntoConstraints = false
        return etv
    }()
}

//MARK: - Lifecycle
extension EventTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}
//MARK: - Set Up UI
extension EventTableViewController{
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
        
        
        arrModel = Model.all()
        eventTableView.reloadData()
        
        
    }
}

// MARK: - TableView Delegate / Datasource
extension EventTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "TaskCell",for: indexPath)as! TaskCell
        let model  = arrModel[indexPath.row]
        cell.updateCell(model:  model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let vc = TaskDetailsViewController()
      self.navigationController?.pushViewController(vc, animated: true)
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
        done.image = UIGraphicsImageRenderer(size: CGSize(width: 24, height: 31)).image { _ in
            #imageLiteral(resourceName: "DoneIcon").draw(in: CGRect(x: 0, y: 0, width: 24, height: 31))
        }
    
        let configuration = UISwipeActionsConfiguration(actions: [done])
        return configuration
    }
    
    private func handleTrash(indexPath: IndexPath) {
      print("Trash")
        self.arrModel.remove(at: indexPath.row)
        self.eventTableView.reloadData()

    }
    
    private func handleDone(indexPath: IndexPath){
        print("Done") 
        self.eventTableView.cellForRow(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        self.eventTableView.reloadData()
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
