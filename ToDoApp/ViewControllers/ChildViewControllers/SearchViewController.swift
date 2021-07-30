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

  

//    private let searchView : UIView = {
//        let sw = UIView(frame: .zero)
//        sw.translatesAutoresizingMaskIntoConstraints = false
//        sw.backgroundColor = .clear
//        return sw
//    }()
    
    private let searchTextField : UITextField = {
        let st = UITextField(frame: .zero)
        st.translatesAutoresizingMaskIntoConstraints = false
        st.returnKeyType = .search
        st.backgroundColor = .darkGray
        st.layer.cornerRadius = 8
        st.placeholder = "Search Task"
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16, height: 2.0))
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
    
    private(set) var shouldShowCalendarViewContainer = CurrentValueSubject<Bool, Never>(true)

}
//MARK: - Lifecycle
extension SearchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}
   
//MARK: - Set Up UI
extension SearchViewController{
    func setUpUI() {
        self.view.addSubview(searchTextField)
        self.searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.searchTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        self.searchTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 60/100).isActive = true
        
        
        
//        self.view.addSubview(searchTextField)
//        searchTextField.leadingAnchor(margin: 16)
//            .trailingAnchor(margin: 16)
//            .centerYAnchor(margin: 0)
//            .heightAnchor(50)
//            .widthAnchor(50)
//
//
//        view.addSubview(searchBtn)
//        searchBtn.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor,constant: 0).isActive = true
//        searchBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
//        searchBtn.heightAnchor(30)
//            .widthAnchor(30)
//
        
        searchTextField.delegate = self
       
        searchTextField.addTarget(self, action: #selector(searchTextDidChange), for: .editingChanged)
        
    }
}

//MARK: - Actions
extension SearchViewController : UITextFieldDelegate{
  
    @objc private func searchTextDidChange(){
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NSLog("Did Begin")
        self.shouldShowCalendarViewContainer.send(false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        NSLog("Did End")
        self.shouldShowCalendarViewContainer.send(true)
    }
    
    @objc private func searchTextDidBegin() {
       
    }
}
   
