//
//  HomeViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 24.07.2021.
//

import Foundation
import UIKit
import Combine

class HomeViewController : BaseVC {
    private let viewModel: HomeViewModel = HomeViewModel()
  
    private var cancellables = Set<AnyCancellable>()
    
    private let searchView : UIView = {
        let sw = UIView(frame: .zero)
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.backgroundColor = #colorLiteral(red: 0.462745098, green: 0.2745098039, blue: 1, alpha: 1)
        return sw
    }()
    
    private let searchTextField : UITextField = {
        let st = UITextField(frame: .zero)
        st.translatesAutoresizingMaskIntoConstraints = false
        st.returnKeyType = .search
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
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
}

// MARK: - LifeCycle
extension HomeViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        addListeners()
    }
}

// MARK: - Set Up UI
extension HomeViewController {
    private func setUpUI() {
       
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.view.addSubview(searchView)
        searchView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: C.navigationBarHeight + C.statusBarHeight).isActive = true
        searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0).isActive = true
        searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: 76).isActive = true
        
        searchView.addSubview(searchTextField)
        searchTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -16).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 16).isActive = true
        searchTextField.centerYAnchor.constraint(equalTo: searchView.centerYAnchor, constant: 0).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: searchView.centerXAnchor, constant: 0).isActive = true
        
        searchTextField.addSubview(searchBtn)
        searchBtn.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor,constant: 0).isActive = true
        searchBtn.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: -12).isActive = true
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
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchTextDidChange), for: .editingChanged)
    }
}

// MARK: - Actions
extension HomeViewController {
    override func baseVCAddOnTap() {
        routeToNewTasks()
    }
    
    @objc private func searchTextDidChange() {
        self.viewModel.updateSearchText(self.searchTextField.text ?? "")
    }
}

// MARK: - Listeners
extension HomeViewController {
    private func addListeners() {
        let listenerSearchText = self.viewModel.searchText
            .receive(on: DispatchQueue.main)
        
        listenerSearchText.sink { str in
            print("Current Str: \(str)")
        }.store(in: &cancellables)
    }
}

// MARK: - TableView Delegate / Datasource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

// MARK: - TextfieldDelegate
extension HomeViewController: UITextFieldDelegate {
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

// MARK: - Route
extension HomeViewController {
    private func routeToNewTasks() {
        let newViewController = NewTaskViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
