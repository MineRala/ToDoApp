//
//  HomeViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 24.07.2021.
//

import Foundation
import UIKit
import Combine

enum HomeViewControllerType {
    case defaultType
    case localNotification(value: String)
}

class HomeViewController : BaseVC {
    
    private(set) var viewModel: HomeViewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()  // cancellable değişkeni oluşturduk,elemanları hafızadan atmak için.
   
    private var calendarHeightConstraint: NSLayoutConstraint?
    
    private let searchVCContainer = UIView.view().backgroundColor(C.BackgroundColor.searchVCContainerBackgroundColor)
    private let calendarVCContainer = UIView.view().backgroundColor(C.BackgroundColor.calendarVCContainerBackgroundColor)
    private let eventVCContainer = UIView.view().backgroundColor(C.BackgroundColor.eventVCContainerBackgroundColor)
    
    private var searchVC : SearchViewController!
    private var calendarVC : CalendarViewController!
    private var eventVC : EventTableViewController!
    
    private var homeViewControllerType: HomeViewControllerType = .defaultType
    
    private let calendarViewHeightRatio: CGFloat = 35/100
    
    private let itemsContainerView : UIView = {
        let icv = UIView(frame: .zero)
        icv.translatesAutoresizingMaskIntoConstraints = false
        icv.backgroundColor = C.BackgroundColor.clearColor
        return icv
    }()
    
    deinit {
        self.cancellables.forEach { $0.cancel() }  // cancellabes ile hafızadan çıkardık
    }
}

// MARK: - Lifecycle
extension HomeViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        addListeners()
        viewModel.initializeViewModel()
        
        self.eventVC.fetchDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if calendarHeightConstraint == nil {
            calendarHeightConstraint = calendarVCContainer.heightAnchor.constraint(equalToConstant: self.itemsContainerView.frame.size.height * calendarViewHeightRatio)
            calendarHeightConstraint!.isActive = true
        }
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
        
        self.view.addSubview(itemsContainerView)
        itemsContainerView.leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .bottomAnchor(margin: 0)
        itemsContainerView.topAnchor.constraint(equalTo: searchVCContainer.bottomAnchor, constant: 0).isActive = true
        
        self.itemsContainerView.addSubview(calendarVCContainer)
        calendarVCContainer
            .topAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .leadingAnchor(margin: 0)
        
        self.itemsContainerView.addSubview(eventVCContainer)
        eventVCContainer.topAnchor.constraint(equalTo: calendarVCContainer.bottomAnchor, constant: 0).isActive = true
        eventVCContainer.leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
        eventVCContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        eventVC = EventTableViewController(homeViewModel: viewModel)
        calendarVC = CalendarViewController()
        searchVC = SearchViewController(viewModel: viewModel)
        
        self.addChildViewController(childController: eventVC, onView: eventVCContainer)
        self.addChildViewController(childController: calendarVC, onView: calendarVCContainer)
        self.addChildViewController(childController: searchVC, onView: searchVCContainer)
       
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil 
    }
}

//MARK: - CalenderView Hight Constraint 
extension HomeViewController {
    private func changeCalendarViewHeightConstraint(to value: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.calendarHeightConstraint!.constant = value
            self.view.layoutIfNeeded()
        } completion: { _ in
        }
    }
}

//MARK: - Fetch Data Protocol Delegate
extension HomeViewController: FetchDelegate {
    func fetchData() {
        viewModel.fetchEventsData()
        eventVC.reloadData()
    }
}

//MARK: - Navigate TaskDetailViewController
extension HomeViewController {
    private func navigateToTaskDetailViewControllerIfNeeded() {
        switch self.homeViewControllerType {
        case .localNotification(let value):
            guard let toDoItem = viewModel.searchToDoItem(withNotificationID: value) else {
                print("Unable to retrieve toDoItem from viewModel")
                return
            }
            let vc = TaskDetailsViewController(model: toDoItem)
            self.navigationController?.pushViewController(vc, animated: true)
            self.homeViewControllerType = .defaultType
        case .defaultType:
            print("the HomeViewController type is defaultType.")
            return
        }
    }
}

// MARK: - Listeners (Combine)
extension HomeViewController {
    private func addListeners() {
        self.searchVC.isSearchTextFieldInEditingMode
            .receive(on: DispatchQueue.main)
            .sink { shouldShow in
                shouldShow ?
                    self.changeCalendarViewHeightConstraint(to: self.itemsContainerView.frame.size.height * self.calendarViewHeightRatio) :
                    self.changeCalendarViewHeightConstraint(to: 0)
        }.store(in: &cancellables)
        
        viewModel.shouldChangeScrollOffsetOfEventsTable
            .receive(on: DispatchQueue.main)
            .sink { _ in
            }.store(in: &cancellables)
        
        viewModel.shouldUpdateAllData
            .receive(on: DispatchQueue.main)
            .sink { _ in
            }.store(in: &cancellables)
        
        viewModel.shouldUpdateAllDateWithFilter
            .receive(on: DispatchQueue.main)
            .sink { _ in
            }.store(in: &cancellables)
        
        calendarVC.selectedDate.receive(on: DispatchQueue.main)
            .sink { date in
                self.viewModel.updateSelectedDate(date)
            }.store(in: &cancellables)
    }
}

// MARK: - TextfieldDelegate
extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

// MARK: - Actions
extension HomeViewController {
    override func baseVCAddOnTap() {
        routeToNewTasks()
    }
    
    private func routeToNewTasks() {
        let newViewController = NewAndEditTaskViewController()
        newViewController.fetchDelegate = self
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
}

// MARK: - Public
extension HomeViewController {
    func updateHomeViewControllerType(_ type: HomeViewControllerType) {
        self.homeViewControllerType = type
        self.navigateToTaskDetailViewControllerIfNeeded()
    }
}
