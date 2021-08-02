//
//  TaskCell.swift
//  ToDoApp
//
//  Created by Mine Rala on 27.07.2021.
//

import Foundation
import UIKit
import DeclarativeUI
import DeclarativeLayout

protocol TaskCellDelegate {
    func taskCellDidSelected(_ cell: TaskCell, model: TaskModel)
}

class TaskCell: UITableViewCell {
    
    private let hourInfo = UIStackView.stackView(alignment: .fill, distribution: .fill, spacing: 0, axis: .vertical)
    
    private let taskInfo = UIStackView.stackView(alignment: .fill, distribution: .fill, spacing: 8, axis: .vertical)
    
    private var tap: UITapGestureRecognizer!
    private var model: TaskModel!
    private var delegate: TaskCellDelegate?
    
    let attrStrikethroughStyle = [ NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue) ]

    private let hourLabel : UILabel = {
       let hl = UILabel()
        hl.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        hl.textAlignment = .center
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.font = UIFont(name: C.Font.medium.rawValue, size: 18)
        return hl
    }()
    
    private let hourPeriodLabel : UILabel = {
       let hl = UILabel()
        hl.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        hl.textAlignment = .center
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.font = UIFont(name: C.Font.bold.rawValue, size: 16)
        return hl
    }()
    
    private let taskName : UILabel = {
        let tn = UILabel()
        tn.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        tn.lineBreakMode = .byWordWrapping
        tn.numberOfLines = 0
        tn.translatesAutoresizingMaskIntoConstraints = false
        tn.font = UIFont(name: C.Font.regular.rawValue, size: 20)
        return tn
    }()
    
    private let taskCatagory : UILabel = {
        let tc = UILabel()
        tc.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        tc.translatesAutoresizingMaskIntoConstraints = false
        tc.font = UIFont(name: C.Font.light.rawValue, size: 12)
        return tc
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("cell init")
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
    
        self.selectionStyle = .none
        tap = UITapGestureRecognizer(target: self, action: #selector(tableViewCellTapped))
        
        self.addGestureRecognizer(tap)
        
        print(self.gestureRecognizers)
        print("avslighdkfj")
    }
    
    
    func updateCell(model: TaskModel, delegate: TaskCellDelegate) {
        print("cell update")
        self.model = model
        self.delegate = delegate
        
        if model.isTaskCompleted {
            hourLabel.attributedText = NSAttributedString(string: model.hourLabel, attributes:  attrStrikethroughStyle)
            hourPeriodLabel.attributedText = NSAttributedString(string: model.hourPeriodLabel, attributes: attrStrikethroughStyle)
            taskName.attributedText = NSAttributedString(string: model.taskName, attributes: attrStrikethroughStyle)
            taskCatagory.attributedText = NSAttributedString(string: model.taskCatagory, attributes: attrStrikethroughStyle)
        }else{
            
            hourLabel.attributedText = NSAttributedString(string: model.hourLabel)
            hourPeriodLabel.attributedText = NSAttributedString(string: model.hourPeriodLabel)
            taskName.attributedText = NSAttributedString(string: model.taskName)
            taskCatagory.attributedText = NSAttributedString(string: model.taskCatagory)
        }
        self.layoutIfNeeded()
    }
    
    @objc func tableViewCellTapped() {
        self.delegate?.taskCellDidSelected(self, model: model)
    }
}
    


