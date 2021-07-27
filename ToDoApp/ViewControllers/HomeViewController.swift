//
//  HomeViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 24.07.2021.
//

import Foundation
import UIKit

class HomeViewController : UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    
    var keyWindow : UIWindow {UIApplication.shared.windows.first(where: { $0.isKeyWindow })!}
    
    var filteredText : String = ""
    
    private let viewStatus : UIView = {
        let vw = UIView(frame: .zero)
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)
        return vw
    }()
    
    private let taskView : UIView = {
        let tv = UIView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = #colorLiteral(red: 0.462745098, green: 0.2745098039, blue: 1, alpha: 1)
        return tv
    }()
    
    private let taskLabel : UILabel  = {
        let tl = UILabel(frame: .zero)
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.text = "Tasks"
        tl.font = UIFont(name: "Roboto-Bold" , size: 20 )
        tl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return tl
    }()
    
    private let addBtn : UIButton = {
        let ab = UIButton(frame: .zero)
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.setImage(UIImage(named: "AddIcon"), for: .normal)
        return ab
    }()
    
    private let searchView : UIView = {
        let sw = UIView(frame: .zero)
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.backgroundColor = #colorLiteral(red: 0.462745098, green: 0.2745098039, blue: 1, alpha: 1)
        return sw
    }()
    
    private let searchText : UITextField = {
        let st = UITextField(frame: .zero)
        st.translatesAutoresizingMaskIntoConstraints = false
        st.backgroundColor = .white
        st.layer.cornerRadius = 8
        st.placeholder = "Search Task"
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16   , height: 2.0))
        st.leftView = leftView
        st.leftViewMode = .always
        return st
    }()
    
    private let searchBtn : UIButton = {
        let sb = UIButton(frame: .zero)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.setImage(UIImage(named: "SearchIcon"), for: .normal)
        sb.isEnabled = false
        return sb
    }()
    
    private let calenderView : UIView = {
        let cv = UIView(frame: .zero)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .red
        return cv
    }()
    
    private let eventTableView : UITableView = {
        let etv = UITableView(frame: .zero,style: .plain)
        etv.translatesAutoresizingMaskIntoConstraints = false
        return etv
    }()
    
    private let tableViewNewTask: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.windows.forEach { (window) in
            print("\(window), is key window \(window.isKeyWindow)")
        }
        print(keyWindow)
        
        keyWindow.addSubview(viewStatus)
        viewStatus.topAnchor.constraint(equalTo: keyWindow.topAnchor, constant: 0).isActive = true
        viewStatus.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor, constant: 0).isActive = true
        viewStatus.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor, constant: 0).isActive = true
        viewStatus.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)
        setUpUI()
        searchText.delegate = self
        
        
}
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text{
            filteredText(text+string)
        }
        return true
    }
    
    func filteredText (_ query :String){
        print("\(query)")
    }
    
    private func setUpUI() {
        self.view.addSubview(taskView)
        taskView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        taskView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 0).isActive = true
        taskView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        taskView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        taskView.addSubview(taskLabel)
        taskLabel.centerXAnchor.constraint(equalTo: taskView.centerXAnchor, constant: 0).isActive = true
        taskLabel.topAnchor.constraint(equalTo: taskView.topAnchor, constant: 25).isActive = true
        taskLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        taskLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        taskView.addSubview(addBtn)
        addBtn.trailingAnchor.constraint(equalTo: taskView.trailingAnchor, constant: -16).isActive = true
        addBtn.topAnchor.constraint(equalTo: taskView.topAnchor, constant: 58).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        addBtn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        addBtn.addTarget(nil, action: #selector(addNewTasks), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(searchView)
        searchView.topAnchor.constraint(equalTo: taskView.bottomAnchor, constant: 0).isActive = true
        searchView.leadingAnchor.constraint(equalTo: taskView.leadingAnchor,constant: 0).isActive = true
        searchView.trailingAnchor.constraint(equalTo: taskView.trailingAnchor, constant: 0).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: 76).isActive = true
        
        searchView.addSubview(searchText)
        searchText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchText.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -16).isActive = true
        searchText.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 16).isActive = true
        searchText.centerYAnchor.constraint(equalTo: searchView.centerYAnchor, constant: 0).isActive = true
        searchText.centerXAnchor.constraint(equalTo: searchView.centerXAnchor, constant: 0).isActive = true
        
        searchText.addSubview(searchBtn)
        searchBtn.centerYAnchor.constraint(equalTo: searchText.centerYAnchor,constant: 0).isActive = true
        searchBtn.trailingAnchor.constraint(equalTo: searchText.trailingAnchor, constant: -12).isActive = true
        searchBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        searchBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 0).isActive = true
        calenderView.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: 0).isActive = true
        calenderView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 0).isActive = true
        calenderView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        self.view.addSubview(eventTableView)
        eventTableView.topAnchor.constraint(equalTo: calenderView.bottomAnchor, constant: 0).isActive = true
        eventTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        eventTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        eventTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        eventTableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        eventTableView.dataSource = self
        eventTableView.delegate = self
    }

    @objc func addNewTasks() {
        let newViewController = NewTaskViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "TaskCell",for: indexPath)as! TaskCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
