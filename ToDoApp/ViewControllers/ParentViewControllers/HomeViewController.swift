//
//  HomeViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 24.07.2021.
//

import Foundation
import UIKit
import Combine
import DeclarativeUI
import DeclarativeLayout

protocol CalendarAddedWithHeight {
    var homeViewController : HomeViewController? { get set }
    func changeHight(_ isTextField: Bool)
}

class HomeViewController : BaseVC {
    
    private let viewModel: HomeViewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()  // cancellable değişkeni oluşturduk,elemanları hafızadan atmak için.
   
    var calendarConstraint: NSLayoutConstraint?                                               
    var delegate: CalendarAddedWithHeight? = nil
    
    private let searchVCContainer = UIView.view().backgroundColor(#colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1))
    private let calendarVCContainer = UIView.view().backgroundColor(.blue)
    private let eventVCContainer = UIView.view().backgroundColor(#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1))
    
    private let searchVC : SearchViewController = SearchViewController()
    private let calendarVC : CalendarViewController = CalendarViewController()
    private let eventVC : EventTableViewController = EventTableViewController()

    
    private let itemsContainerView : UIView = {
        let icv = UIView(frame: .zero)
        icv.translatesAutoresizingMaskIntoConstraints = false
        icv.backgroundColor = .clear
        return icv
    }()
    
    deinit {
        self.cancellables.forEach { $0.cancel() }  // cancellabes ile hafızadan çıkardık
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
        
        self.view.addSubview(searchVCContainer)
    
        searchVCContainer.topAnchor(margin: C.navigationBarHeight + C.statusBarHeight)
            .leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .heightAnchor(76)
        
        self.addChildViewController(childController: searchVC, onView: searchVCContainer)
        
        self.view.addSubview(itemsContainerView)
        itemsContainerView.leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .bottomAnchor(margin: 0)
        itemsContainerView.topAnchor.constraint(equalTo: searchVCContainer.bottomAnchor, constant: 0).isActive = true
        
        self.itemsContainerView.addSubview(calendarVCContainer)
        calendarConstraint = NSLayoutConstraint(item: calendarVCContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)

        calendarVCContainer.addConstraint(calendarConstraint!)
        calendarConstraint?.constant = CGFloat(500)
        
        calendarVCContainer.topAnchor(margin: 0).trailingAnchor(margin: 0).leadingAnchor(margin: 0)
//        calendarVCContainer.heightAnchor.constraint(equalTo: itemsContainerView.heightAnchor, multiplier: 35/100).isActive = true
        self.addChildViewController(childController: calendarVC, onView: calendarVCContainer)
        
        self.itemsContainerView.addSubview(eventVCContainer)
        
        eventVCContainer.topAnchor.constraint(equalTo: calendarVCContainer.bottomAnchor, constant: 0).isActive = true
        eventVCContainer.leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
        eventVCContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        self.addChildViewController(childController: eventVC, onView: eventVCContainer)
    }
}

// MARK: - Actions
extension HomeViewController {
    override func baseVCAddOnTap() {
        routeToNewTasks()
    }
}

// MARK: - Listeners
extension HomeViewController {
    private func addListeners() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
        
        let listenerSearchText = self.viewModel.searchText
            .receive(on: DispatchQueue.main) //Main treate aldık.
        
        listenerSearchText.sink { str in // sink ile dinledik.
            print("Current Str: \(str)")
        }.store(in: &cancellables)// cancellables ile hafızadan çıkardık.
        
    }
    @objc func hideKeyboard() {
        self.view.endEditing(true)

     }
}

// MARK: - TextfieldDelegate
extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}

// MARK: - Route
extension HomeViewController  {
   
    
    private func routeToNewTasks() {
        let newViewController = NewTaskViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
