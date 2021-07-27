//
//  NewTaskViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 26.07.2021.
//

import Foundation
import UIKit

class NewTaskViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate{
    
    private let newTaskView : UIView = {
        let ntv = UIView(frame: .zero)
        ntv.translatesAutoresizingMaskIntoConstraints = false
        ntv.backgroundColor = #colorLiteral(red: 0.462745098, green: 0.2745098039, blue: 1, alpha: 1)
        return ntv
    }()
    
    private let taskLabel : UILabel  = {
        let tl = UILabel(frame: .zero)
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.text = "New Task"
        tl.font = UIFont(name: "Roboto-Bold" , size: 20 )
        tl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return tl
    }()
    
    private let backBtn : UIButton = {
        let bb = UIButton(frame: .zero)
        bb.translatesAutoresizingMaskIntoConstraints = false
        bb.setImage(UIImage(named: "BackIcon"), for: .normal)
        return bb
    }()
    
    private let tableViewNewTask: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .blue
        return tv
    }()
    
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
        self.view.addSubview(newTaskView)
        newTaskView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        newTaskView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 0).isActive = true
        newTaskView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        newTaskView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        newTaskView.addSubview(taskLabel)
        taskLabel.centerXAnchor.constraint(equalTo: newTaskView.centerXAnchor, constant: 0).isActive = true
        taskLabel.topAnchor.constraint(equalTo: newTaskView.topAnchor, constant: 25).isActive = true
        taskLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        taskLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        newTaskView.addSubview(backBtn)
        backBtn.leadingAnchor.constraint(equalTo: newTaskView.leadingAnchor, constant: 16).isActive = true
        backBtn.topAnchor.constraint(equalTo: newTaskView.topAnchor, constant: 58).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backBtn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backBtn.addTarget(nil, action: #selector(backBtnPressed), for: UIControl.Event.touchUpInside)
        
        
        self.view.addSubview(tableViewNewTask)
        
        tableViewNewTask.topAnchor.constraint(equalTo: newTaskView.bottomAnchor, constant: 12).isActive = true
        tableViewNewTask.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableViewNewTask.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableViewNewTask.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        tableViewNewTask.register(NewTaskCell.self, forCellReuseIdentifier: "NewTaskCell")
        tableViewNewTask.dataSource = self
        tableViewNewTask.delegate = self
        tableViewNewTask.separatorStyle = .none
        
        self.tableViewNewTask.reloadData()
        
        self.view.addSubview(addBtn)
      
        addBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        addBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        addBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: self.view.frame.width/7).isActive = true
        addBtn.addTarget(nil, action: #selector(addBtnPressed), for: UIControl.Event.touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        //UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
       }
       
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableViewNewTask.dequeueReusableCell(withIdentifier: "NewTaskCell",for: indexPath)as? NewTaskCell{
           cell.selectionStyle = .none
          //  print(indexPath.row)
//            let textField: UITextField = cell.textField
//            textField.delegate = self
            return cell
        }
       
        return UITableViewCell()
    }
    
    @objc func backBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
