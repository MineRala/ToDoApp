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
    private var cancellables = Set<AnyCancellable>()  // cancellable değişkeni oluşturduk,elemanları hafızadan atmak için.
   
    private var calendarHeightConstraint: NSLayoutConstraint?
    
    private let searchVCContainer = UIView.view().backgroundColor(#colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1))
    private let calendarVCContainer = UIView.view().backgroundColor(#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1))
    private let eventVCContainer = UIView.view().backgroundColor(#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1))
    
    private var searchVC : SearchViewController!
    private var calendarVC : CalendarViewController!
    private var eventVC : EventTableViewController!
    
    private let calendarViewHeightRatio: CGFloat = 35/100
    let notificationCenter = UNUserNotificationCenter.current()
    
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
        localNotification()
        viewModel.initializeViewModel()
      //  eventVC.delegateRetrieveTaskDetail = self
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
        calendarVC = CalendarViewController(viewModel: viewModel)
        searchVC = SearchViewController(viewModel: viewModel)
        
        self.addChildViewController(childController: eventVC, onView: eventVCContainer)
        self.addChildViewController(childController: calendarVC, onView: calendarVCContainer)
        self.addChildViewController(childController: searchVC, onView: searchVCContainer)
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

////MARK: - Edit Protocol Delegate
//extension HomeViewController: RetriveTaskEditVDMDelegate {
//    func getTaskEditVDM(index: Int) -> TaskEditVDM? {
//        if index < 0 || index >=  {
//            return nil
//        }
//        return viewModel.arrEditTaskListData[index]
//    }
//}

// MARK: - Actions
extension HomeViewController {
    override func baseVCAddOnTap() {
        routeToNewTasks()
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
                //NSLog("Scroll Should Change")
            }.store(in: &cancellables)
        
        viewModel.shouldUpdateAllData
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
                //self.eventTableView.reloadData()
        }.store(in: &cancellables)
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
    
    //TODO
    // Get new task from newTaskViewController(Protocol)
}

//MARK: - Local Notification
extension HomeViewController {
    func localNotification(){
       
        let content = UNMutableNotificationContent()
        content.title = "Hey I'am a notification"
        content.body = "Look at me!"
        
        let date =  Date().addingTimeInterval(5)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
         notificationCenter.add(request) { (error) in
            if error != nil {
                print("Error" + error.debugDescription)
                return
            }
        }
    }
}
