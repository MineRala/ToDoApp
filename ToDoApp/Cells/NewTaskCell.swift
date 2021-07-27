//
//  NewTaskCell.swift
//  ToDoApp
//
//  Created by Mine Rala on 26.07.2021.
//

import Foundation
import UIKit

class NewTaskCell: UITableViewCell{

//    class TextField: UITextField {
//            override func textRect(forBounds bounds: CGRect) -> CGRect {
//                return bounds.insetBy(dx: 24, dy: 0)
//            }
//
//            override func editingRect(forBounds bounds: CGRect) -> CGRect {
//                return bounds.insetBy(dx: 24, dy: 0)
//            }
//
//            override var intrinsicContentSize: CGSize {
//                return .init(width: 0, height: 44)
//            }
//        }
//
//        let textField: UITextField = {
//            let tf = TextField()
//            tf.translatesAutoresizingMaskIntoConstraints = false
//            tf.placeholder = "Edit me"
//            tf.backgroundColor = .cyan
//            tf.isUserInteractionEnabled = true
//            return tf
//        }()
//
//        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//            super.init(style: style, reuseIdentifier: reuseIdentifier)
//            addSubview(textField)
//            textField.frame = bounds
//        }
//
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//

    
    private let textField : UITextField = {
        let tvc = UITextField(frame: .zero)
        tvc.translatesAutoresizingMaskIntoConstraints = false
        tvc.backgroundColor = .clear
        tvc.borderStyle = .roundedRect
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

        self.addSubview(textField)
        textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 500).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 100).isActive = true

}
}
