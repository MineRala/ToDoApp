//
//  CustomTaskCell.swift
//  ToDoApp
//
//  Created by Mine Rala on 6.08.2021.
//

import Foundation
import UIKit

class HeaderTaskCell: UITableViewCell {
    
    private(set) var date: Date!
    private let dayLabel : UILabel = {
       let dl = UILabel()
        dl.textColor = #colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)
        dl.textAlignment = .center
        dl.translatesAutoresizingMaskIntoConstraints = false
        dl.font = UIFont(name: C.Font.regular.rawValue, size: 20)
        return dl
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Set Up UI
extension HeaderTaskCell {
    func setUpUI(){
        self.contentView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)
        self.contentView.addSubview(dayLabel)
        dayLabel.topAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .leadingAnchor(margin: 0)
            .bottomAnchor(margin: 0)
    }
}

//MARK: - Actions
extension HeaderTaskCell {
    func updateHeaderCell(title: String, date: Date) {
        self.dayLabel.text = title
        self.date = date
    }
}
