//
//  CustomTaskCell.swift
//  ToDoApp
//
//  Created by Mine Rala on 6.08.2021.
//

import Foundation
import UIKit

class HeaderTaskCell: UITableViewCell {
    
    private let dayLabel : UILabel = {
       let dl = UILabel()
        dl.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        dl.textAlignment = .center
        dl.translatesAutoresizingMaskIntoConstraints = false
        dl.font = UIFont(name: C.Font.medium.rawValue, size: 18)
        dl.text = "Today"
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
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(dayLabel)
        dayLabel.topAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .leadingAnchor(margin: 0)
            .bottomAnchor(margin: 0)
    }
    
    
}
