//
//  SearchViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 28.07.2021.
//

import Foundation
import UIKit
import Combine

class SearchViewController : UIViewController {
    private(set) var isSearchTextFieldInEditingMode = CurrentValueSubject<Bool, Never>(true)

    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    private var cancelBtnWidthConstraint: NSLayoutConstraint?
    private var searchBtnWidthConstraint: NSLayoutConstraint?
    
    private let searchView : UIView = {
        let sw = UIView(frame: .zero)
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sw.layer.cornerRadius = 8
        return sw
    }()

    private let searchTextField : UITextField = {
        let st = UITextField(frame: .zero)
        st.translatesAutoresizingMaskIntoConstraints = false
        st.returnKeyType = .search
        st.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        st.layer.cornerRadius = 8
        st.placeholder = NSLocalizedString("Search Task", comment: "")
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16, height: 2.0))
        st.leftView = leftView
        st.leftViewMode = .always
        st.clearButtonMode = .whileEditing
        return st
    }()
    
    private let searchBtn : UIButton = {
        let sb = UIButton(frame: .zero)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.setImage(UIImage(named: "SearchIcon"), for: .normal)
        sb.isEnabled = false
        return sb
    }()
    
    private let cancelBtn : UIButton = {
        let cb = UIButton(frame: .zero)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cb.setTitleColor(.white, for: .normal)
        cb.titleFont(UIFont(name: C.Font.bold.rawValue, size: 16)!)
        return cb
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() }
    }
}

//MARK: - Lifecycle
extension SearchViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addListeners()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if cancelBtnWidthConstraint == nil {
            cancelBtnWidthConstraint = cancelBtn.widthAnchor.constraint(equalToConstant: 0)
            cancelBtnWidthConstraint!.isActive = true
        }
        if searchBtnWidthConstraint == nil {
            searchBtnWidthConstraint = searchBtn.widthAnchor.constraint(equalToConstant: 30)
            searchBtnWidthConstraint!.isActive = true
        }
    }
}
   
//MARK: - Set Up UI
extension SearchViewController{
    func setUpUI() {
        
        self.view.addSubview(searchView)
        searchView.leadingAnchor(margin: 16).centerYAnchor(margin: 0)
            .heightAnchor(50)
        
        self.view.addSubview(cancelBtn)
        searchView.trailingAnchor.constraint(equalTo: self.cancelBtn.leadingAnchor, constant: -8).isActive = true
        
        self.searchView.addSubview(searchTextField)
        self.searchView.addSubview(searchBtn)
        
        cancelBtn.centerYAnchor(margin: 0)
            .trailingAnchor(margin: 12)
        
        searchTextField.leadingAnchor(margin: 0)
            .centerYAnchor(margin: 0)
            .heightAnchor(50)
        
        searchTextField.trailingAnchor.constraint(equalTo: searchBtn.leadingAnchor, constant: -16).isActive = true
        
        searchBtn.centerYAnchor(margin: 0)
            .trailingAnchor(margin: 4)
            .heightAnchor(30)
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchTextDidChange), for: .editingChanged)
        cancelBtn.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
    }
}

//MARK: - Change Constraint
extension SearchViewController {
    private func changeConstraint(viewConstraint constaint: NSLayoutConstraint?, to value: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            constaint!.constant = value
            self.view.layoutIfNeeded()
        } completion: { _ in
        }
    }
}

// MARK: - Listeners (Combine)
extension SearchViewController {
    private func addListeners() {
        self.isSearchTextFieldInEditingMode
            .receive(on: DispatchQueue.main)
            .sink { isSearchTextFieldEditingMode in
                isSearchTextFieldEditingMode ?
                    self.changeConstraint(viewConstraint: self.cancelBtnWidthConstraint, to: 0) :
                    self.changeConstraint(viewConstraint: self.cancelBtnWidthConstraint, to: 60)
                isSearchTextFieldEditingMode ?
                    self.changeConstraint(viewConstraint: self.searchBtnWidthConstraint, to: 30) :
                    self.changeConstraint(viewConstraint: self.searchBtnWidthConstraint, to: 0)
        }.store(in: &cancellables)
    }
}

//MARK: - Actions
extension SearchViewController : UITextFieldDelegate {
  
    @objc private func searchTextDidChange(){
        
        if searchTextField.text == "" {
            self.viewModel.arrTaskListDataFiltered.send(self.viewModel.arrTaskListData)
            return
        }
            
        var arrToDoItemFiltered = [TaskListVDM]()
        for taskList in viewModel.arrTaskListData {
            if taskList.taskName.lowercased().contains((searchTextField.text?.lowercased())!) {
                arrToDoItemFiltered.append(taskList)
            }
        }
        self.viewModel.arrTaskListDataFiltered.send(arrToDoItemFiltered)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NSLog("Did Begin")
        self.isSearchTextFieldInEditingMode.send(false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        NSLog("Did End")
        self.isSearchTextFieldInEditingMode.send(true)
        if searchTextField.text == "" {
            self.viewModel.arrTaskListDataFiltered.send(self.viewModel.arrTaskListData)
        }
        else {
        }
    }
    
    @objc private func cancelBtnTapped() {
        NSLog("Cancel Button Tapped")
        self.searchTextField.text = ""
        self.searchTextField.endEditing(true)
        self.isSearchTextFieldInEditingMode.send(true)
        self.viewModel.arrTaskListDataFiltered.send(self.viewModel.arrTaskListData)
    }
}
 
//MARK: - Keyboard Search UIButton
extension SearchViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     if textField.text?.count == 0 {
            textField.resignFirstResponder()
        }
     else{
        textField.resignFirstResponder()
        self.isSearchTextFieldInEditingMode.send(false)
     }
        return true
    }    
}
