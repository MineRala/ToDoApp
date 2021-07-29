//
//  EventTableViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 28.07.2021.
//

import Foundation
import UIKit

class EventTableViewController : UIViewController{

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
        eventTableView.reloadData()
    }
}

// MARK: - TableView Delegate / Datasource
extension EventTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "TaskCell",for: indexPath)as! TaskCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
