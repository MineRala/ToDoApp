//
//  ScrollView.swift
//  ToDoApp
//
//  Created by Aybek Can Kaya on 27.07.2021.
//

import Foundation
import UIKit

//MARK: - ScrollView Cell
class ScrollViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        self.backgroundColor = C.BackgroundColor.clearColor
    }
}

//MARK: ScrollView Protocol
protocol ScrollViewDataSource {
    func scrollViewElements(_ scrollView: ScrollView, cell: ScrollViewCell)
}


class ScrollView: UITableView {
    
    private var dataSourceScrollView: ScrollViewDataSource!
    
    init(dataSource: ScrollViewDataSource) {
        super.init(frame: .zero, style: .plain)
        self.dataSourceScrollView = dataSource
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Set Up UI
extension ScrollView {
    private func setUpUI() {
        self.separatorStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(ScrollViewCell.self, forCellReuseIdentifier: "ScrollViewCell")
        self.delegate = self
        self.dataSource = self
        self.reloadData()
    }
}

//MARK: - TableView Delegate / DataSource
extension ScrollView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScrollViewCell", for: indexPath) as! ScrollViewCell
        cell.selectionStyle = .none
        dataSourceScrollView.scrollViewElements(self, cell: cell)
        return cell
    }
}
