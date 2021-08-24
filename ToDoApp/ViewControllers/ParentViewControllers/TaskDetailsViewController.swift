//
//  TaskDetailsViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 29.07.2021.
//

import Foundation
import UIKit
 
protocol TaskCellDeleteAndDoneDelegate {
    func taskCellDeleted(toDoItem: ToDoItem)
    func taskCellDoneTapped(toDoItem: ToDoItem)
}

class TaskDetailsViewController : BaseVC, NSLayoutManagerDelegate {
   
    private let viewBottom = UIView.view().backgroundColor(C.BackgroundColor.viewBottomBackgroundColor)
    private var textViewHeightConstraint: NSLayoutConstraint!
    private var viewDetailHeightConstriant: NSLayoutConstraint!

    var fetchDelegate: FetchDelegate?
    var delegate: TaskCellDeleteAndDoneDelegate?
    var delegateModeSelection: SetPageModeToNewTaskViewControllerDelegate?
    var detailModel: DetailTaskViewModel!
    
    private let viewContinue: UIView = {
        let vc = UIView(frame: .zero)
        vc.translatesAutoresizingMaskIntoConstraints = false
        vc.backgroundColor = C.BackgroundColor.viewContinueBackgroundColor
        return vc
    }()
    
    private let viewDetail: UIView = {
        let vd = UIView(frame: .zero)
        vd.translatesAutoresizingMaskIntoConstraints = false
        vd.backgroundColor = C.BackgroundColor.viewDetailBackgroundColor
        vd.layer.cornerRadius = 4
        vd.sizeToFit()
        vd.taskDetailsShadow()
        return vd
    }()
    
    private let labelTaskName: UILabel = {
        let ltn = UILabel(frame: .zero)
        ltn.translatesAutoresizingMaskIntoConstraints = false
        ltn.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        ltn.font = UIFont(name: C.Font.medium.rawValue, size: 20)
        return ltn
    }()
    
    private let labelDate: UILabel = {
        let ld = UILabel(frame: .zero)
        ld.translatesAutoresizingMaskIntoConstraints = false
        ld.textColor = C.BackgroundColor.labelDateTextColor
        ld.font = UIFont(name: C.Font.regular.rawValue, size: 16)
        return ld
    }()
    
    private var textViewDescription : UITextView = {
        let tvd = UITextView(frame: .zero)
        tvd.translatesAutoresizingMaskIntoConstraints = true
        tvd.textColor = C.BackgroundColor.textViewDescriptionTextColor
        tvd.font = UIFont(name: C.Font.regular.rawValue, size: 16)
        tvd.isEditable = false
        tvd.isUserInteractionEnabled = true
        tvd.isScrollEnabled = false
        return tvd
    }()

    private let buttonDelete : UIButton = {
        let bd = UIButton(frame: .zero)
        bd.translatesAutoresizingMaskIntoConstraints = false
        bd.setImage(C.ImageIcon.trashIcon, for: .normal)
        return bd
    }()
    
    private let buttonEdit : UIButton = {
        let be = UIButton(frame: .zero)
        be.translatesAutoresizingMaskIntoConstraints = false
        be.setImage(C.ImageIcon.editIcon, for: .normal)
        return be
    }()
    private let buttonDone : UIButton = {
        let bd = UIButton(frame: .zero)
        bd.translatesAutoresizingMaskIntoConstraints = false
        bd.setImage(C.ImageIcon.checkIcon, for: .normal)
        return bd
    }()
    
    init(model: ToDoItem) {
        super.init(nibName: nil, bundle: nil)
        self.detailModel = DetailTaskViewModel(toDoItem: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Lifecycle
extension TaskDetailsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if detailModel.detailTaskVDM!.isTaskCompleted {
            self.buttonDone.setImage(C.ImageIcon.undoIcon, for: .normal)
        }
        
        labelTaskName.text = detailModel.detailTaskVDM!.taskName
        textViewDescription.text = detailModel.detailTaskVDM!.taskDescription
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setScollability(textView: self.textViewDescription)
    }
}
    
//MARK: - Set Up UI Components
extension TaskDetailsViewController{
    private func setUpUI() {
        self.view.addSubview(viewContinue)
        viewContinue.topAnchor(margin: C.navigationBarHeight + C.statusBarHeight)
            .leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .heightAnchor(76)
        
        self.view.addSubview(viewDetail)
        viewDetail.topAnchor.constraint(equalTo: viewContinue.topAnchor, constant: 16).isActive = true
        viewDetail.leadingAnchor(margin: 20).trailingAnchor(margin: 20)

        self.viewDetail.addSubview(labelTaskName)
        labelTaskName.topAnchor(margin: 36)
            .leadingAnchor(margin: 16)
            .trailingAnchor(margin: 16)
            .heightAnchor(24)

        self.viewDetail.addSubview(labelDate)
        labelDate.topAnchor.constraint(equalTo: labelTaskName.bottomAnchor, constant: 16).isActive = true
        labelDate.leadingAnchor(margin: 16)
            .trailingAnchor(margin: 16)
            .heightAnchor(24)
  
        self.viewDetail.addSubview(textViewDescription)
        textViewDescription.topAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 16).isActive = true
        textViewDescription.leadingAnchor(margin: 16)
            .trailingAnchor(margin: 16)
        textViewDescription.bottomAnchor.constraint(equalTo: viewDetail.bottomAnchor, constant: -16).isActive = true

        
        self.view.addSubview(viewBottom)
        viewBottom.leadingAnchor(margin: 0).trailingAnchor(margin: 0).bottomAnchor(margin: 0).heightAnchor(view.frame.width/6)
        
        let stackBottom = UIStackView.stackView(alignment: .fill, distribution: .fillEqually, spacing: 0, axis: .horizontal)
        viewBottom.addSubview(stackBottom)
        stackBottom.heightAnchor(60).leadingAnchor(margin: 0).trailingAnchor(margin: 0).topAnchor(margin: 0)
        
        viewDetail.bottomAnchor.constraint(lessThanOrEqualTo: viewBottom.topAnchor, constant: -16).isActive = true
        
        viewBottom.taskDetailsShadow()
        
        let deleteButtonContainer = UIView.view().backgroundColor(C.BackgroundColor.clearColor)
        let editButtonContainer = UIView.view().backgroundColor(C.BackgroundColor.clearColor)
        let doneButtonContainer = UIView.view().backgroundColor(C.BackgroundColor.clearColor)
        
        deleteButtonContainer.addSubview(buttonDelete)
        editButtonContainer.addSubview(buttonEdit)
        doneButtonContainer.addSubview(buttonDone)
        
        stackBottom.addArrangedSubview(deleteButtonContainer)
        stackBottom.addArrangedSubview(editButtonContainer)
        stackBottom.addArrangedSubview(doneButtonContainer)

        buttonDelete.alignToCenter(margins: .zero).dimensions(CGSize(width: 20, height: 24))
        buttonDone.alignToCenter(margins: .zero).dimensions(CGSize(width: 20, height: 24))
        buttonEdit.alignToCenter(margins: .zero).dimensions(CGSize(width: 20, height: 24))

        
        buttonDelete.addTarget(nil, action: #selector(deleteButtonTapped), for: UIControl.Event.touchUpInside)
        buttonEdit.addTarget(nil, action: #selector(editButtonTapped), for: UIControl.Event.touchUpInside)
        buttonDone.addTarget(nil, action: #selector(doneButtonTapped), for: UIControl.Event.touchUpInside)
    
      
        textViewDescription.layoutManager.delegate = self
        
        textViewDescription.textContainerInset = UIEdgeInsets.fill(with: 0)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func setScollability(textView: UITextView) {
        let sizeThatFitsTextView = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        let heightOfText = sizeThatFitsTextView.height
        if heightOfText >= self.textViewDescription.frame.size.height {
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
        }
    }
}

//MARK: - Actions
extension TaskDetailsViewController{
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 8
    }
    
    @objc func deleteButtonTapped() {
        Alerts.showAlertDelete(controller: self, NSLocalizedString("Are you sure you want to delete the task?", comment: "")) {
            self.delegate?.taskCellDeleted(toDoItem: self.detailModel.getToDoItem())
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func editButtonTapped() {
        let vc = NewAndEditTaskViewController(toDoItem: self.detailModel.getToDoItem())
        vc.fetchDelegate = self
        vc.updateTaskDetailVDMDelegate = self
        self.delegateModeSelection?.setPageMode(mode: .editTask)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func doneButtonTapped() {
        self.delegate?.taskCellDoneTapped(toDoItem: self.detailModel.getToDoItem())
        self.navigationController?.popViewController(animated: true)
    }
}
   
//MARK: - Fetch Delegate
extension TaskDetailsViewController: FetchDelegate {
    func fetchData() {
        self.fetchDelegate?.fetchData()
    }
}

// MARK: - UpdateTaskDetailVDMToTaskDetailViewController {
extension TaskDetailsViewController : UpdateTaskDetailVDMToTaskDetailViewController {
    func updateTaskDetailVDM() {
        detailModel.updateDetailTaskVDM()
    }
}
