//
//  SelectDateViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 29.07.2021.
//

import Foundation
import UIKit
import Combine

protocol SelectDateViewControllerDelegate {
    func selectDateViewControllerDidSelectedDate(_ viewController: SelectDateViewController, date: Date)
}

class SelectDateViewController : BaseVC {
    
    private let viewModel: HomeViewModel = HomeViewModel()
    private let calendarVCContainer = UIView.view().backgroundColor(C.BackgroundColor.calendarVCContainerBackgroundColor)
    private var calendarVC : CalendarViewController!
    private var selectDelegate: SelectDateViewControllerDelegate
    private var date: Date
    private var cancellables = Set<AnyCancellable>()
    private var shouldDisplayToast: Bool = false
    
    var taskTimePicker = UIDatePicker()

    private let timeView: UIView = {
        let tv = UIView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = C.BackgroundColor.clearColor
        tv.taskDetailsShadow()
        tv.backgroundColor = C.BackgroundColor.timeViewBackgroundColor
        tv.layer.cornerRadius = 8
        return tv
    }()
    
    private let itemContainerView : UIView = {
        let icv = UIView(frame: .zero)
        icv.translatesAutoresizingMaskIntoConstraints = false
        icv.backgroundColor = C.BackgroundColor.clearColor
        return icv
    }()
    
    private let selectButton : UIButton = {
        let sb = UIButton(frame: .zero)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.backgroundColor = C.BackgroundColor.selectButtonBackgroundColor
        sb.setTitle(NSLocalizedString("Select", comment: ""), for: .normal)
        sb.titleLabel?.font = C.Font.medium.font(21)
        return sb
    }()
    
    
    init(date: Date, selectDateDelegate: SelectDateViewControllerDelegate) {
        self.date = date
        self.selectDelegate = selectDateDelegate
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
extension SelectDateViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTimePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            taskTimePicker.preferredDatePickerStyle = .wheels
        }
        setUpUI()
        addListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskTimePicker.setDate(date, animated: true)
    }
}

//MARK: - Set Up UI
extension SelectDateViewController{
    private func setUpUI(){
        self.view.backgroundColor = C.BackgroundColor.selectDateViewBackgroundColor
        self.view.addSubview(itemContainerView)
        itemContainerView.leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .bottomAnchor(margin: 0)
        itemContainerView.topAnchor(margin: C.navigationBarHeight + C.statusBarHeight)
        
        self.itemContainerView.addSubview(calendarVCContainer)
        
        calendarVCContainer.topAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .leadingAnchor(margin: 0)
        
        calendarVCContainer.heightAnchor.constraint(equalTo: itemContainerView.heightAnchor, multiplier: 40/100).isActive = true
 
        self.itemContainerView.addSubview(timeView)
        self.itemContainerView.addSubview(selectButton)
        
        timeView.topAnchor.constraint(equalTo: calendarVCContainer.bottomAnchor, constant: 32).isActive = true
        timeView.leadingAnchor(margin: 32)
            .trailingAnchor(margin: 32)

        timeView.addSubview(taskTimePicker)
        taskTimePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
        taskTimePicker.trailingAnchor(margin: 0).leadingAnchor(margin: 0).topAnchor(margin: 0).bottomAnchor(margin: 0)
        
        selectButton.bottomAnchor(margin: 0)
            .leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .heightAnchor(view.frame.width/5)
    
        timeView.bottomAnchor.constraint(equalTo: selectButton.topAnchor, constant: -32).isActive = true
        
        selectButton.addTarget(nil, action: #selector(selectButtonTapped), for: .touchUpInside)
        
        calendarVC = CalendarViewController()
        calendarVC.setDate(date: date)
        self.addChildViewController(childController: calendarVC, onView: calendarVCContainer)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
}

//MARK: - Set Date
extension SelectDateViewController {
    func setDate(date: Date){
        self.date = date
    }
}


//MARK: - AddListeners
extension SelectDateViewController {
    func addListeners() {
        self.calendarVC.selectedDate
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.updateDate()
            }.store(in: &cancellables)
    }
}

//MARK: - Actions
extension SelectDateViewController {
    @objc func selectButtonTapped(){
        
        if self.date < Date() {
            Alerts.showAlertInvalidDate(controller: self, title: NSLocalizedString("Invalid date", comment: ""), message: NSLocalizedString("You cannot select the past date!", comment: ""), completion: {
                return
            })
        }
        let date: Date = calendarVC.getSelectedDate()
        let components = Calendar.current.dateComponents([.day, .year, .month], from: date)
        
        var dateComponents = DateComponents()
        dateComponents.year = components.year
        dateComponents.month = components.month
        dateComponents.day = components.day

        let datePicker = taskTimePicker.date
        let pickerDateComponent = Calendar(identifier: .gregorian).dateComponents([.hour, .minute], from: datePicker)
        dateComponents.hour = pickerDateComponent.hour
        dateComponents.minute = pickerDateComponent.minute
        
        let userCalendar = Calendar.current
        let selectedDate = userCalendar.date(from: dateComponents)
    
        self.selectDelegate.selectDateViewControllerDidSelectedDate(self, date: selectedDate!)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        self.updateDate()
    }
}

//MARK: - Update Date
extension SelectDateViewController {
    func updateDate() {
        self.date = self.viewModel.combineJoinedDate(selectedDate: self.calendarVC.selectedDate.value, taskTimePickerDate: self.taskTimePicker.date)
        if self.date < Date() {
            if self.shouldDisplayToast {
                ToastView.show(with: NSLocalizedString("Warning: You cannot select the past date!", comment: ""))
            }
            self.shouldDisplayToast = true
            self.calendarVC.changeSelectionColor(to: C.BackgroundColor.changeSelectionPastDateColor)
        } else {
            self.calendarVC.changeSelectionColor(to: C.BackgroundColor.changeSelectionColor)
        }
    }
}
