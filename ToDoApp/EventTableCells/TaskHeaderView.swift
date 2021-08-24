//
//  CustomTaskCell.swift
//  ToDoApp
//
//  Created by Mine Rala on 6.08.2021.
//

import Foundation
import UIKit

class TaskHeaderView: UITableViewHeaderFooterView {
    
    private(set) var date: Date!
    private(set) var indexPath: IndexPath!
    
    private let dayLabel : UILabel = {
       let dl = UILabel()
        dl.textColor = C.BackgroundColor.dayLabelTextColor
        dl.textAlignment = .center
        dl.translatesAutoresizingMaskIntoConstraints = false
        dl.font = UIFont(name: C.Font.regular.rawValue, size: 20)
        return dl
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Set Up UI
extension TaskHeaderView {
    func setUpUI(){
        self.backgroundColor = C.BackgroundColor.contentViewBackgroundColor
        self.addSubview(dayLabel)
        dayLabel.topAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .leadingAnchor(margin: 0)
            .bottomAnchor(margin: 0)
    }
}

//MARK: - Actions
extension TaskHeaderView {
    func updateHeaderCell(title: String, date: Date) {
        self.dayLabel.text = title
        self.date = date
       
    }
}
