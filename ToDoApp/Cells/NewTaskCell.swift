//
//  NewTaskCell.swift
//  ToDoApp
//
//  Created by Mine Rala on 26.07.2021.
//

import Foundation
import UIKit

class NewTaskCell: UITableViewCell{
    
    private let textField : UITextField = {
        let tvc = UITextField(frame: .zero)
        tvc.translatesAutoresizingMaskIntoConstraints = false
        tvc.backgroundColor = .clear
        tvc.borderStyle = .line
        return tvc
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {

        self.contentView.addSubview(textField)
        
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        

}
}
