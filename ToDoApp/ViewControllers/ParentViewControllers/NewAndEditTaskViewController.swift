//NewAndEditTaskViewController
//  NewAndEditTaskViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 26.07.2021.
//

import Foundation
import UIKit
import Combine

protocol SetPageModeToNewTaskViewControllerDelegate {
    func setPageMode(mode: NewAndEditVCState)
}

protocol AddActionsInPickerViewNewAndEditViewControllerDelegate {
    func didTapDone()
    func didTapCancel()
}

protocol FetchDelegate {
    func fetchData()
}

protocol UpdateTaskDetailVDMToTaskDetailViewController {
    func updateTaskDetailVDM()
}

class NewAndEditTaskViewController: BaseVC, UITextFieldDelegate, ScrollViewDataSource {
    
    private var scrollViewAddTask: ScrollView!
    private let stackView = UIStackView.stackView(alignment: .fill, distribution: .fill, spacing: 32, axis: .vertical)
    
  
    var notificationPickerView =  ToolbarPickerView()
    var model: NewAndEditViewModel!
    var fetchDelegate: FetchDelegate?
    var updateTaskDetailVDMDelegate: UpdateTaskDetailVDMToTaskDetailViewController?
    private var cancellables = Set<AnyCancellable>()
        
    private let taskNameTextField = FloatingTextfield()
        .textInsets(dx: 2, dy: 0)
        .defaultBottomLineColor(C.BackgroundColor.defaultColor)
        .editingBottomLineColor(C.BackgroundColor.editingColor)
        .defaultTitleColor(C.BackgroundColor.defaultColor)
        .editingTitleColor(C.BackgroundColor.editingColor)
        .backgroundColor(C.BackgroundColor.floatingTextFieldBackgroundColor)
        .asFloatingTextfield()
    
    private let descriptionTextField = FloatingTextfield()
        .textInsets(dx: 2, dy: 0)
        .defaultBottomLineColor(C.BackgroundColor.defaultColor)
        .editingBottomLineColor(C.BackgroundColor.editingColor)
        .defaultTitleColor(C.BackgroundColor.defaultColor)
        .editingTitleColor(C.BackgroundColor.editingColor)
        .backgroundColor(C.BackgroundColor.floatingTextFieldBackgroundColor)
        .asFloatingTextfield()
    
    private let categoryFLTextfield = FloatingTextfield()
        .textInsets(dx: 2, dy: 0)
        .defaultBottomLineColor(C.BackgroundColor.defaultColor)
        .editingBottomLineColor(C.BackgroundColor.editingColor)
        .defaultTitleColor(C.BackgroundColor.defaultColor)
        .editingTitleColor(C.BackgroundColor.editingColor)
        .backgroundColor(C.BackgroundColor.floatingTextFieldBackgroundColor)
        .asFloatingTextfield()
    
    private let pickDateFLTextField = FloatingTextfield()
        .textInsets(dx: 2, dy: 0)
        .defaultBottomLineColor(C.BackgroundColor.defaultColor)
        .editingBottomLineColor(C.BackgroundColor.editingColor)
        .defaultTitleColor(C.BackgroundColor.defaultColor)
        .editingTitleColor(C.BackgroundColor.editingColor)
        .backgroundColor(C.BackgroundColor.floatingTextFieldBackgroundColor)
        .asFloatingTextfield()
    
    private  let notification = FloatingTextfield()
        .textInsets(dx: 2, dy: 0)
        .defaultBottomLineColor(C.BackgroundColor.defaultColor)
        .editingBottomLineColor(C.BackgroundColor.editingColor)
        .defaultTitleColor(C.BackgroundColor.defaultColor)
        .editingTitleColor(C.BackgroundColor.editingColor)
        .backgroundColor(C.BackgroundColor.floatingTextFieldBackgroundColor)
        .asFloatingTextfield()

    private let addBtn: UIButton = {
        let ab = UIButton(frame: .zero)
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.setTitleColor(C.BackgroundColor.addButtonSetTitleColor, for: .normal)
        ab.titleLabel?.font = UIFont(name: C.Font.medium.rawValue, size: 20)
        ab.backgroundColor = C.BackgroundColor.addButtonBackgroundColor
        ab.tintColor = C.BackgroundColor.addButtonTintColor
        return ab
    }()
    
    private let pickDateButton: UIButton = {
        let ab = UIButton(frame: .zero)
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.backgroundColor = C.BackgroundColor.clearColor
        return ab
    }()

    init(toDoItem: ToDoItem? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.model = NewAndEditViewModel(toDoItem: toDoItem)
        
        if model.getMode() ==  .newTask { //New Task
            taskNameTextField.title(NSLocalizedString("Task Name", comment: ""))
            descriptionTextField.title(NSLocalizedString("Description", comment: ""))
            categoryFLTextfield.title(NSLocalizedString("Category", comment: ""))
            pickDateFLTextField.title(NSLocalizedString("Pick Date & Time", comment: ""))
            notification.title(NSLocalizedString("Notification", comment: ""))
        }
        else{
            taskNameTextField.title(model.editTaskVDM!.taskNameTitle)
            descriptionTextField.title(model.editTaskVDM!.taskDescriptionTitle)
            categoryFLTextfield.title(model.editTaskVDM!.taskCategoryTitle)
            pickDateFLTextField.title(model.editTaskVDM!.taskDateTitle)
            notification.title(model.editTaskVDM!.notificationDateTitle)
        }
        self.closeAutoCorrection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() }  // cancellabes ile hafızadan çıkardık
    }
}

//MARK: - Lifecycle
extension NewAndEditTaskViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateTaskTitle(string: model.getMode().navigationBarTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpPickerView()
        addObservers()
        addListeners()
    }
}


//MARK: - Set Up UI And PickerView
extension NewAndEditTaskViewController {
    func setUpUI() {
        view.backgroundColor = C.BackgroundColor.newAndEditViewBackgroundColor
        self.scrollViewAddTask = ScrollView(dataSource: self)
        self.scrollViewAddTask.backgroundColor = C.BackgroundColor.clearColor
        self.scrollViewAddTask.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.scrollViewAddTask)
        scrollViewAddTask
            .topAnchor(margin: C.navigationBarHeight+C.statusBarHeight)
            .leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)

        self.scrollViewAddTask.reloadData()
        
        pickDateFLTextField.addSubview(pickDateButton)
        pickDateButton.trailingAnchor(margin: 0).leadingAnchor(margin: 0).topAnchor(margin: 0).bottomAnchor(margin: 0)
        
        
        notification.inputView = notificationPickerView
        notification.textFieldShouldChangeCharacters { (notification, NSRange, String) -> (Bool) in
            return false
        }
        
        notificationPickerView.backgroundColor = C.BackgroundColor.notificationPicerViewBackgroundColor
        notificationPickerView.setValue(C.BackgroundColor.notificationPicerViewSetValueColor, forKey: "textColor")
        
        self.view.addSubview(addBtn)
        addBtn.bottomAnchor(margin: 0)
            .leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .heightAnchor(view.frame.width/5)
            
        self.addBtn.setTitle(model.getMode().confirmButtonTitle, for: .normal)
    
        pickDateButton.addTarget(nil, action: #selector(pickDateButtonTapped), for: UIControl.Event.touchUpInside)
        addBtn.addTarget(nil, action: #selector(addBtnPressed), for: UIControl.Event.touchUpInside)
        
        scrollViewAddTask.bottomAnchor(margin: 0)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil 
    }
    
    func setUpPickerView() {
        notificationPickerView.delegate = self
        notificationPickerView.dataSource = self
        self.notificationPickerView.toolbarDelegate = self
        notification.inputAccessoryView = notificationPickerView.toolbar
        self.notificationPickerView.reloadAllComponents()

        let notificationTitleAndRow = self.model.getNotificationTitleAndRow(notificationDate: model.toDoItem.notificationDate, taskDate: model.toDoItem.taskDate!)
        self.notificationPickerView.selectRow(notificationTitleAndRow.1, inComponent: 0, animated: true)
        self.model.setNotificationTime(notificationTime: notificationTitleAndRow.0)
    }
    
    private func closeAutoCorrection() {
        taskNameTextField.autoCorrectionType(.no)
        descriptionTextField.autoCorrectionType(.no)
        categoryFLTextfield.autoCorrectionType(.no)
    }
}

//MARK: - Observers & Listeners
extension NewAndEditTaskViewController {
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(NewAndEditTaskViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewAndEditTaskViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
      else {
        return
      }
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        scrollViewAddTask.contentInset = contentInsets
        scrollViewAddTask.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        scrollViewAddTask.contentInset = contentInsets
        scrollViewAddTask.scrollIndicatorInsets = contentInsets
    }
    
    private func addListeners() {
        
        self.model.shouldDisplayAlertForInvalidNotification
            .receive(on: DispatchQueue.main)
            .sink { dict in
                guard let title = dict["title"] else { return }
                guard let message = dict["message"] else { return }
                guard let taskName = dict["taskName"] else { return }
                guard let description = dict["description"] else { return }
                guard let category = dict["category"] else { return }
                Alerts.showAlertInvalidNotificationDate(controller: self, title: title, message: message, completion: { isAnswerYes in
                    if isAnswerYes {
                        self.model.removeNotificationTime()
                        let isSuccess = self.model.createNewItem(taskName: taskName, taskDescription: description, taskCategory: category)
                        if isSuccess{
                            self.updateTaskDetailVDMDelegate?.updateTaskDetailVDM()
                            self.navigationController?.popViewController(animated: true)
                            self.fetchDelegate?.fetchData()
                        }
                    }
                })
            }.store(in: &cancellables)
    }
}
   
//MARK: - ScrollView Elements
extension NewAndEditTaskViewController {
    func scrollViewElements(_ scrollView: ScrollView, cell: ScrollViewCell) {
        cell.contentView.addSubview(stackView)
        stackView.leadingAnchor(margin: 8)
            .trailingAnchor(margin: 8)
            .topAnchor(margin: 32)
            .bottomAnchor(margin: 32)
        
        let textfieldDefaultHeight: CGFloat = 44
       
        stackView.backgroundColor(C.BackgroundColor.stackViewBackgroundColor)
        
        let viewTop = UIView().backgroundColor(C.BackgroundColor.viewTopBackgroundColor).heightAnchor(0)
        stackView.addArrangedSubview(viewTop)
        
        stackView.addArrangedSubview(taskNameTextField)
        taskNameTextField.heightAnchor(textfieldDefaultHeight)
        
        stackView.addArrangedSubview(descriptionTextField)
        descriptionTextField.heightAnchor(textfieldDefaultHeight)
        
        stackView.addArrangedSubview(categoryFLTextfield)
        categoryFLTextfield.heightAnchor(textfieldDefaultHeight)
        
        stackView.addArrangedSubview(pickDateFLTextField)
        stackView.setCustomSpacing(0, after: pickDateFLTextField)
        pickDateFLTextField.heightAnchor(textfieldDefaultHeight)
        
        let view = UIView().backgroundColor(C.BackgroundColor.viewBackgroundColor).heightAnchor(30)
        stackView.addArrangedSubview(view)
        
        stackView.addArrangedSubview(notification)
        notification.heightAnchor(textfieldDefaultHeight)
        
        if model.getMode() == .editTask {
           setEditPageMode()
        }
    }
}
  
//MARK: - Edit Page Mode
extension NewAndEditTaskViewController {
    private func setEditPageMode(){
        taskNameTextField.asFloatingTextfield().text = self.model.editTaskVDM!.taskName
        descriptionTextField.asFloatingTextfield().text = self.model.editTaskVDM!.taskDescription
        categoryFLTextfield.asFloatingTextfield().text = self.model.editTaskVDM!.taskCategory
        pickDateFLTextField.asFloatingTextfield().text = self.model.editTaskVDM!.taskDateFormated
        let notificationTimeText = self.model.getNotificationTitleAndRow(notificationDate: self.model.editTaskVDM!.notificationDate, taskDate: self.model.editTaskVDM!.taskDate).0
        notification.asFloatingTextfield().text = notificationTimeText
    }
}

//MARK: - PickerView Delegate & DataSource
extension NewAndEditTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.arrNotificationTime.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return model.arrNotificationTime[row]
    }
}

extension NewAndEditTaskViewController: AddActionsInPickerViewNewAndEditViewControllerDelegate {
    func didTapDone() {
        let row = self.notificationPickerView.selectedRow(inComponent: 0)
        self.notificationPickerView.selectRow(row, inComponent: 0, animated: false)
        updateNotificationTime(withTitle: self.model.arrNotificationTime[row])
        notification.resignFirstResponder()
    }
    
    func didTapCancel() {
        notification.resignFirstResponder()
    }
}
extension NewAndEditTaskViewController {
    func updateNotificationTime(withTitle notificationTime: String) {
        self.notification.text = notificationTime
        self.model.setNotificationTime(notificationTime: notificationTime)
    }
}
//MARK: - Actions
extension NewAndEditTaskViewController {
    @objc func addBtnPressed() {
        let taskName = taskNameTextField.asFloatingTextfield().text
        let description =  descriptionTextField.asFloatingTextfield().text
        let category =  categoryFLTextfield.asFloatingTextfield().text
        let isSuccess = model.createNewItem(taskName: taskName, taskDescription: description, taskCategory: category)
        if isSuccess {
            self.updateTaskDetailVDMDelegate?.updateTaskDetailVDM()
            self.navigationController?.popViewController(animated: true)
            self.fetchDelegate?.fetchData()
        }
    }
    
    @objc func pickDateButtonTapped() {
        
        if model.getMode() == .newTask {
            let vc = SelectDateViewController(date: Date(), selectDateDelegate: self)
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        let date = self.model.selectedDate == nil ? model.toDoItem.taskDate! : self.model.selectedDate!
        let vc = SelectDateViewController(date: date, selectDateDelegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//MARK: - Set Select Date Delegate
extension NewAndEditTaskViewController : SelectDateViewControllerDelegate {
    func selectDateViewControllerDidSelectedDate(_ viewController: SelectDateViewController, date: Date) {
        model.selectedDate = date
        pickDateFLTextField.asFloatingTextfield().text = TaskVDMConverter.formatDateForEditTaskVDM(date: date)
    }
}
