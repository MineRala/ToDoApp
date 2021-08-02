//
//  SearchViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 28.07.2021.
//

import Foundation
import UIKit
import Combine
import DeclarativeUI
import DeclarativeLayout

class SearchViewController : UIViewController {
    private(set) var shouldShowCalendarViewContainer = CurrentValueSubject<Bool, Never>(true)
    private(set) var buttonImage = CurrentValueSubject<UIImage, Never>(#imageLiteral(resourceName: "SearchIcon"))
    
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
        st.placeholder = "Search Task"
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
        
        self.view.addSubview(searchView)
        searchView.leadingAnchor(margin: 16).centerYAnchor(margin: 0)
            .heightAnchor(50)
            .trailingAnchor(margin: 12)

        self.searchView.addSubview(searchTextField)
        self.searchView.addSubview(searchBtn)

        searchTextField.leadingAnchor(margin: 0)
            .centerYAnchor(margin: 0)
            .heightAnchor(50)
        
        searchTextField.trailingAnchor.constraint(equalTo: searchBtn.leadingAnchor, constant: -16).isActive = true
        
        searchBtn.centerYAnchor(margin: 0)
            .trailingAnchor(margin: 3)
            .heightAnchor(30)
            .widthAnchor(30)
        
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
    
}
   
