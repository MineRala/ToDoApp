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
    
    private let addBtn: UIButton = {
        let ab = UIButton(frame: .zero)
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.setTitle("ADD", for: .normal)
        ab.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        ab.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 20)
        ab.backgroundColor = #colorLiteral(red: 0.462745098, green: 0.2745098039, blue: 1, alpha: 1)
        ab.tintColor = .white
        return ab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)
        setUpUI()
    }
    
    func setUpUI() {
        
        self.view.addSubview(addBtn)
      
        addBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        addBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        addBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: self.view.frame.width/7).isActive = true
        addBtn.addTarget(nil, action: #selector(addBtnPressed), for: UIControl.Event.touchUpInside)
        
        self.scrollViewAddTask = ScrollView(dataSource: self)
        self.scrollViewAddTask.backgroundColor = .clear
        self.scrollViewAddTask.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollViewAddTask)
        
        self.scrollViewAddTask
            .topAnchor.constraint(equalTo: self.view.topAnchor, constant: C.navigationBarHeight + C.statusBarHeight)
            .isActive = true
        self.scrollViewAddTask.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.scrollViewAddTask.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.scrollViewAddTask.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        self.scrollViewAddTask.reloadData()
    }
    
  
    func scrollViewElements(_ scrollView: ScrollView, cell: ScrollViewCell) {
        cell.contentView.addSubview(stackView)
        stackView.leadingAnchor(margin: 8).trailingAnchor(margin: 8).topAnchor(margin: 32).bottomAnchor(margin: 32)
        
        let textfieldDefaultHeight: CGFloat = 44
        
        let defaultColor = UIColor.lightGray
        let editingColor = UIColor.black
        
        let taskNameFLTextfield = FloatingTextfield
            .floatingTextField()
            .textInsets(dx: 2, dy: 0)
            .defaultBottomLineColor(defaultColor)
            .editingBottomLineColor(editingColor)
            .defaultTitleColor(defaultColor)
            .editingTitleColor(editingColor)
            .title("Task Name")
        stackView.addArrangedSubview(taskNameFLTextfield)
        taskNameFLTextfield.heightAnchor(textfieldDefaultHeight)
        
        let categoryFLTextfield = FloatingTextfield
            .floatingTextField()
            .textInsets(dx: 2, dy: 0)
            .defaultBottomLineColor(defaultColor)
            .editingBottomLineColor(editingColor)
            .defaultTitleColor(defaultColor)
            .editingTitleColor(editingColor)
            .title("Category")
        stackView.addArrangedSubview(categoryFLTextfield)
        categoryFLTextfield.heightAnchor(textfieldDefaultHeight)
       
//        let textfieldTaskName = UITextField
//            .textfield()
//            .borderStyle(.roundedRect)
//        stackView.addArrangedSubview(textfieldTaskName)
//        textfieldTaskName.heightAnchor(textfieldDefaultHeight)
//
//        let textfieldDateTime = UITextField
//            .textfield()
//            .borderStyle(.roundedRect)
//        stackView.addArrangedSubview(textfieldDateTime)
//        textfieldDateTime.heightAnchor(textfieldDefaultHeight)
//
//        let textfieldCategory = UITextField
//            .textfield()
//            .borderStyle(.roundedRect)
//        stackView.addArrangedSubview(textfieldCategory)
//        textfieldCategory.heightAnchor(textfieldDefaultHeight)
        
       
        
    }
    
    @objc func backBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
