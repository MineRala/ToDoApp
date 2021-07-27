//
//  TaskCell.swift
//  ToDoApp
//
//  Created by Mine Rala on 27.07.2021.
//

import Foundation
import UIKit

class TaskCell: UITableViewCell {
    
    private let hourLabel : UILabel = {
       let hl = UILabel()
        hl.text = "10:00"
        hl.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.font = UIFont(name: "Roboto-Medium", size: 18)
        return hl
    }()
    
    private let hourPeriodLabel : UILabel = {
       let hl = UILabel()
        hl.text = "AM"
        hl.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.font = UIFont(name: "Roboto-Bold", size: 16)
        return hl
    }()
    
    private let taskName : UILabel = {
        let tn = UILabel()
        tn.text = "Arkadaşlar ile Eskişehir'de buluşma"
        tn.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
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
    
    func setUpUI(){
        addSubview(hourLabel)
        hourLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        hourLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        hourLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(hourPeriodLabel)
        hourPeriodLabel.topAnchor.constraint(equalTo: hourLabel.bottomAnchor, constant: 4).isActive = true
        hourPeriodLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32).isActive = true
        hourPeriodLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(taskName)
        taskName.leadingAnchor.constraint(equalTo: hourLabel.trailingAnchor, constant: 30).isActive = true
        taskName.topAnchor.constraint(equalTo: hourLabel.topAnchor, constant: 0).isActive = true
        taskName.heightAnchor.constraint(equalToConstant: 20 ).isActive = true
        
        addSubview(taskCatagory)
        taskCatagory.leadingAnchor.constraint(equalTo: hourPeriodLabel.trailingAnchor, constant: 40).isActive = true
        taskCatagory.topAnchor.constraint(equalTo: hourPeriodLabel.topAnchor, constant: 0).isActive = true
        taskCatagory.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
