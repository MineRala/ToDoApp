//
//  TaskCell.swift
//  ToDoApp
//
//  Created by Mine Rala on 27.07.2021.
//

import Foundation
import UIKit
import  DeclarativeUI
import  DeclarativeLayout

class TaskCell: UITableViewCell {
    
    private let hourInfo = UIStackView.stackView(alignment: .fill, distribution: .fill, spacing: 0, axis: .vertical)
    
    private let taskInfo = UIStackView.stackView(alignment: .fill, distribution: .fill, spacing: 8, axis: .vertical)
    
    private let hourLabel : UILabel = {
       let hl = UILabel()
        hl.text = "10:00"
        hl.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        hl.textAlignment = .center
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.font = UIFont(name: "Roboto-Medium", size: 18)
        return hl
    }()
    
    private let hourPeriodLabel : UILabel = {
       let hl = UILabel()
        hl.text = "AM"
        hl.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        hl.textAlignment = .center
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.font = UIFont(name: "Roboto-Bold", size: 16)
        return hl
    }()
    
    private let taskName : UILabel = {
        let tn = UILabel()
        tn.text = "Arkadaşlar ile Eskişehir'de asd buluşma.Arkadaşlar ile Eskişehir'de buluşma. "
        tn.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        tn.lineBreakMode = .byWordWrapping
        tn.numberOfLines = 0
        tn.translatesAutoresizingMaskIntoConstraints = false
        tn.font = UIFont(name: "Roboto-Regular", size: 20)
        return tn
    }()
    
    private let taskCatagory : UILabel = {
        let tc = UILabel()
        tc.text = "Official"
        tc.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        tc.translatesAutoresizingMaskIntoConstraints = false
        tc.font = UIFont(name: "Roboto-Light", size: 12)
        return tc
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
extension TaskCell {
    func setUpUI(){
        self.contentView.backgroundColor = .clear
        
        contentView.addSubview(hourInfo)
        hourInfo.addArrangedSubview(hourLabel)
        hourInfo.addArrangedSubview(hourPeriodLabel)
        
        hourInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        hourInfo.centerYAnchor(margin: 0)
        hourInfo.widthAnchor.constraint(equalToConstant: 60).isActive = true
        hourInfo.backgroundColor = .clear
        hourPeriodLabel.backgroundColor = .clear
        
        contentView.addSubview(taskInfo)
        taskInfo.addArrangedSubview(taskName)
        taskInfo.addArrangedSubview(taskCatagory)

    
        taskInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        taskInfo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        taskInfo.leadingAnchor.constraint(equalTo: hourInfo.trailingAnchor, constant: 0).isActive = true
        taskInfo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
       
    }
}
    


