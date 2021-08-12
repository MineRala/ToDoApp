//
//  NewTaskViewController.swift
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

protocol AddNewTaskDelegate {
    func passTask(toDoItem: ToDoItem)
}

class NewTaskViewController: BaseVC, UITextFieldDelegate, ScrollViewDataSource {
    
    private var scrollViewAddTask: ScrollView!
    private let stackView = UIStackView.stackView(alignment: .fill, distribution: .fill, spacing: 32, axis: .vertical)
    
    let arrNotificationTime = [NSLocalizedString("5 Minutes Before", comment: ""),
                               NSLocalizedString("10 Minutes Before", comment: ""),
                               NSLocalizedString("15 Minutes Before", comment: ""),
                               NSLocalizedString("30 Minutes Before", comment: ""),
                               NSLocalizedString("1 Hour Before", comment: ""),
                               NSLocalizedString("2 Hours Before", comment: ""),
                               NSLocalizedString("5 Hours Before", comment: ""),
                               NSLocalizedString("1 Day Before", comment: ""),
                               NSLocalizedString("2 Days Before", comment: "")]
    
    var notificationPickerView = UIPickerView()
    
    private var model: TaskEditVDM!
    var delegate: AddNewTaskDelegate!
    private var pageMode: NewAndEditVCState = .newTask
    var newToDoItem = ToDoItem()
 
    static let editingColor = UIColor.black
    static let defaultColor = UIColor.lightGray
    
    private let taskNameTextField = FloatingTextfield()
        .textInsets(dx: 2, dy: 0)
        .defaultBottomLineColor(defaultColor)
        .editingBottomLineColor(editingColor)
        .defaultTitleColor(defaultColor)
        .editingTitleColor(editingColor)
        .backgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        .asFloatingTextfield()
    
    private let descriptionTextField = FloatingTextfield()
        .textInsets(dx: 2, dy: 0)
        .defaultBottomLineColor(defaultColor)
        .editingBottomLineColor(editingColor)
        .defaultTitleColor(defaultColor)
        .editingTitleColor(editingColor)
        .backgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        .asFloatingTextfield()
    
    private let categoryFLTextfield = FloatingTextfield()
        .textInsets(dx: 2, dy: 0)
        .defaultBottomLineColor(defaultColor)
        .editingBottomLineColor(editingColor)
        .defaultTitleColor(defaultColor)
        .editingTitleColor(editingColor)
        .backgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        .asFloatingTextfield()
    
    private let pickDateFLTextField = FloatingTextfield()
        .textInsets(dx: 2, dy: 0)
        .defaultBottomLineColor(defaultColor)
        .editingBottomLineColor(editingColor)
        .defaultTitleColor(defaultColor)
        .editingTitleColor(editingColor)
        .backgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        .asFloatingTextfield()
    
    private  let notification = FloatingTextfield()
        .textInsets(dx: 2, dy: 0)
        .defaultBottomLineColor(defaultColor)
        .editingBottomLineColor(editingColor)
        .defaultTitleColor(defaultColor)
        .editingTitleColor(editingColor)
        .backgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        .asFloatingTextfield()

    private let addBtn: UIButton = {
        let ab = UIButton(frame: .zero)
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        ab.titleLabel?.font = UIFont(name: C.Font.medium.rawValue, size: 20)
        ab.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)
        ab.tintColor = .white
        return ab
    }()
    
    private let pickDateButton: UIButton = {
        let ab = UIButton(frame: .zero)
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.backgroundColor = .clear
        return ab
    }()

    init(model: TaskEditVDM? = nil) {
        super.init(nibName: nil, bundle: nil)
        if model ==  nil { //New Task
            taskNameTextField.title("Task Name")
            descriptionTextField.title("Description")
            categoryFLTextfield.title("Category")
            pickDateFLTextField.title("Pick Date & Time")
            notification.title("Notification")
        }
        else{
            self.model = model
            taskNameTextField.title(model!.taskNameTitle)
            descriptionTextField.title(model!.taskDescriptionTitle)
            categoryFLTextfield.title(model!.taskCategoryTitle)
            pickDateFLTextField.title(model!.taskDateTitle)
            notification.title(model!.notificationDateTitle)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Lifecycle
extension NewTaskViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateTaskTitle(string: pageMode.navigationBarTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationPickerView.delegate = self
        notificationPickerView.dataSource = self
        self.pageMode = getMode(model)
        setUpUI()
       
    }
}

//MARK: - Set Up UI
extension NewTaskViewController {
    func setUpUI() {
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)
        self.scrollViewAddTask = ScrollView(dataSource: self)
        self.scrollViewAddTask.backgroundColor = .clear
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
        
        notificationPickerView.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)
        notificationPickerView.setValue(UIColor.white, forKey: "textColor")
        
        self.view.addSubview(addBtn)
        addBtn.bottomAnchor(margin: 0)
            .leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .heightAnchor(view.frame.width/5)
            
        self.addBtn.setTitle(pageMode.confirmButtonTitle, for: .normal)
    
        pickDateButton.addTarget(nil, action: #selector(pickDateButtonTapped), for: UIControl.Event.touchUpInside)
        addBtn.addTarget(nil, action: #selector(addBtnPressed), for: UIControl.Event.touchUpInside)
        
        scrollViewAddTask.bottomAnchor(margin: 0)
        
    }
}

//MARK: - Get Page Mode
extension NewTaskViewController {
    private func getMode(_ model: TaskEditVDM?) -> NewAndEditVCState {
        if model == nil {
            return .newTask
        } else {
            return .editTask
        }
    }
}

//MARK: - Set Page Mode Protocol
extension NewTaskViewController : SetPageModeToNewTaskViewControllerDelegate {
    func setPageMode(mode: NewAndEditVCState) {
        self.pageMode = mode
    }
}
   
//MARK: - ScrollView Elements
extension NewTaskViewController {
    func scrollViewElements(_ scrollView: ScrollView, cell: ScrollViewCell) {
        cell.contentView.addSubview(stackView)
        stackView.leadingAnchor(margin: 8)
            .trailingAnchor(margin: 8)
            .topAnchor(margin: 32)
            .bottomAnchor(margin: 32)
        
        let textfieldDefaultHeight: CGFloat = 44
       
        stackView.backgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        
        let viewTop = UIView().backgroundColor(#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)).heightAnchor(0)
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
        
        let view = UIView().backgroundColor(#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)).heightAnchor(30)
        stackView.addArrangedSubview(view)
        
        stackView.addArrangedSubview(notification)
        notification.heightAnchor(textfieldDefaultHeight)
        
          if pageMode == .editTask {
           setEditPageMode()
          }
    }
}
  
//MARK: - Edit Page Mode
extension NewTaskViewController {
    private func setEditPageMode(){
        taskNameTextField.asFloatingTextfield().text = self.model.taskName
        descriptionTextField.asFloatingTextfield().text = self.model.taskDescription
        categoryFLTextfield.asFloatingTextfield().text = self.model.taskCategory
        pickDateFLTextField.asFloatingTextfield().text = self.model.taskDate
        notification.asFloatingTextfield().text = self.model.notificationDate
    }
}

//MARK: - PickerView Delegate & DataSource
extension NewTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrNotificationTime.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrNotificationTime[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        notification.text = arrNotificationTime[row]
        notification.resignFirstResponder()
    }
}
//MARK: - Action
extension NewTaskViewController {
    @objc func addBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func pickDateButtonTapped() {
        let vc = SelectDateViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

