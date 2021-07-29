//
//  SearchViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 28.07.2021.
//

import Foundation
import UIKit

class SearchViewController : UIViewController {
    
    private let viewModel: HomeViewModel = HomeViewModel()

    private let searchView : UIView = {
        let sw = UIView(frame: .zero)
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.backgroundColor = .clear
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
    
}
//MARK: - Lifecycle
extension SearchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}
   
//MARK: - Set Up UI
extension SearchViewController : UITextFieldDelegate{
    func setUpUI() {
 
        self.view.addSubview(searchTextField)
        searchTextField.leadingAnchor(margin: 16)
            .trailingAnchor(margin: 16)
            .centerXAnchor(margin: 0)
            .centerYAnchor(margin: 0)
            .heightAnchor(50)
        
        
        searchTextField.addSubview(searchBtn)
        searchBtn.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor,constant: 0).isActive = true
        searchBtn.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: -12).isActive = true
        searchBtn.heightAnchor(30)
            .widthAnchor(30)
        
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchTextDidChange), for: .editingChanged)
        
    }
}

//MARK: - Actions
extension SearchViewController {
    @objc private func searchTextDidChange() {
        self.viewModel.updateSearchText(self.searchTextField.text ?? "")
    }
}
   
