//
//  NewTaskViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 26.07.2021.
//

import Foundation
import UIKit
import DeclarativeLayout
import DeclarativeUI
import FloatingTextfield

class NewTaskViewController: BaseVC, UITextFieldDelegate, ScrollViewDataSource {
    
    private var scrollViewAddTask: ScrollView!
    private let stackView = UIStackView.stackView(alignment: .fill, distribution: .fill, spacing: 32, axis: .vertical)
    
    var model : TaskModel?
    
    private var pageMode: NewAndEditVCState = .newTask
    
    private func getMode(_ model: TaskModel?) -> NewAndEditVCState {
        if model == nil {
            return .newTask
        } else {
            return .editTask
        }
    }
    
    private let addBtn: UIButton = {
        let ab = UIButton(frame: .zero)
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.setTitle("ADD", for: .normal)
        ab.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        ab.titleLabel?.font = UIFont(name: C.Font.medium.rawValue, size: 20)
        ab.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)
        ab.tintColor = .white
        return ab
    }()
    
    init(model: TaskModel? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateTaskTitle(string: pageMode.navigationBarTitle)
    }
}

//MARK: - Lifecycle
extension NewTaskViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageMode = getMode(model)
        setUpUI()
        self.hideKeyboardWhenTappedAround()
    }
}
      
//MARK: - Set Up UI
extension NewTaskViewController {
    func setUpUI() {
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)
        self.scrollViewAddTask = ScrollView(dataSource: self)
        self.scrollViewAddTask.backgroundColor = .clear
        self.scrollViewAddTask.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.scrollViewAddTask)
        scrollViewAddTask
            .topAnchor(margin: C.navigationBarHeight+C.statusBarHeight)
            .leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)

        self.scrollViewAddTask.reloadData()
        
        
        self.view.addSubview(addBtn)
        addBtn.bottomAnchor(margin: 0)
            .leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .heightAnchor(view.frame.width/5)
            
        self.addBtn.setTitle(pageMode.confirmButtonTitle, for: .normal)

        addBtn.addTarget(nil, action: #selector(addBtnPressed), for: UIControl.Event.touchUpInside)
        
        scrollViewAddTask.bottomAnchor(margin: 0)
        
    }
}
   
//MARK: - ScrollView Elements
extension NewTaskViewController {
    func scrollViewElements(_ scrollView: ScrollView, cell: ScrollViewCell) {
        cell.contentView.addSubview(stackView)
        stackView.leadingAnchor(margin: 8)
            .trailingAnchor(margin: 8)
            .topAnchor(margin: 32)
            .bottomAnchor(margin: 32)
        
        let textfieldDefaultHeight: CGFloat = 44
        
        let defaultColor = UIColor.lightGray
        let editingColor = UIColor.black
        stackView.backgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        
        let viewTop = UIView().backgroundColor(#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)).heightAnchor(0)
        stackView.addArrangedSubview(viewTop)
        
        let taskNameFLTextfield = FloatingTextfield
            .floatingTextField()
            .textInsets(dx: 2, dy: 0)
            .defaultBottomLineColor(defaultColor)
            .editingBottomLineColor(editingColor)
            .defaultTitleColor(defaultColor)
            .editingTitleColor(editingColor)
            .title("Task Name")
            .backgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        stackView.addArrangedSubview(taskNameFLTextfield)
        taskNameFLTextfield.heightAnchor(textfieldDefaultHeight)
        
        let description = FloatingTextfield
            .floatingTextField()
            .textInsets(dx: 2, dy: 0)
            .defaultBottomLineColor(defaultColor)
            .editingBottomLineColor(editingColor)
            .defaultTitleColor(defaultColor)
            .editingTitleColor(editingColor)
            .title("Description")
            .backgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        stackView.addArrangedSubview(description)
        description.heightAnchor(textfieldDefaultHeight)
       
        
        let categoryFLTextfield = FloatingTextfield
            .floatingTextField()
            .textInsets(dx: 2, dy: 0)
            .defaultBottomLineColor(defaultColor)
            .editingBottomLineColor(editingColor)
            .defaultTitleColor(defaultColor)
            .editingTitleColor(editingColor)
            .title("Category")
            .backgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        stackView.addArrangedSubview(categoryFLTextfield)
        categoryFLTextfield.heightAnchor(textfieldDefaultHeight)
        
        
        let pickDateFLTextField = FloatingTextfield
            .floatingTextField()
            .textInsets(dx: 2, dy: 0)
            .defaultBottomLineColor(defaultColor)
            .editingBottomLineColor(editingColor)
            .defaultTitleColor(defaultColor)
            .editingTitleColor(editingColor)
            .title("Pick Date & Time")
            .backgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        stackView.addArrangedSubview(pickDateFLTextField)
        stackView.setCustomSpacing(0, after: pickDateFLTextField)
        pickDateFLTextField.heightAnchor(textfieldDefaultHeight)
        
        let view = UIView().backgroundColor(#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)).heightAnchor(30)
        stackView.addArrangedSubview(view)
        
        
        let notification = FloatingTextfield
            .floatingTextField()
            .textInsets(dx: 2, dy: 0)
            .defaultBottomLineColor(defaultColor)
            .editingBottomLineColor(editingColor)
            .defaultTitleColor(defaultColor)
            .editingTitleColor(editingColor)
            .title("Notification")
            .backgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        stackView.addArrangedSubview(notification)
        notification.heightAnchor(textfieldDefaultHeight)
        
    }
}
  
//MARK: - Action
extension NewTaskViewController {
        @objc func addBtnPressed() {
            self.navigationController?.popViewController(animated: true)
        }
}
