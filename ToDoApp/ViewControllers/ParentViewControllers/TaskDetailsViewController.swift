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
   
    private let viewBottom = UIView.view().backgroundColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    private var textViewHeightConstraint: NSLayoutConstraint!
    private var viewDetailHeightConstriant: NSLayoutConstraint!

    var fetchDelegate: FetchDelegate?
    var delegate: TaskCellDeleteAndDoneDelegate?
    var delegateModeSelection: SetPageModeToNewTaskViewControllerDelegate?
    var detailModel: DetailTaskViewModel!
    
    private let viewContinue: UIView = {
        let vc = UIView(frame: .zero)
        vc.translatesAutoresizingMaskIntoConstraints = false
        vc.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)
        return vc
    }()
    
    private let viewDetail: UIView = {
        let vd = UIView(frame: .zero)
        vd.translatesAutoresizingMaskIntoConstraints = false
        vd.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        vd.layer.cornerRadius = 4
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
        ld.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        ld.font = UIFont(name: C.Font.regular.rawValue, size: 16)
        return ld
    }()
    
    private let textViewDescription : UITextView = {
        let tvd = UITextView(frame: .zero)
        tvd.translatesAutoresizingMaskIntoConstraints = false
        tvd.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 0.75)
        tvd.font = UIFont(name: C.Font.regular.rawValue, size: 16)
        tvd.isEditable = false
        tvd.isUserInteractionEnabled = true
        tvd.isScrollEnabled = true
        return tvd
    }()

    private let buttonDelete : UIButton = {
        let bd = UIButton(frame: .zero)
        bd.translatesAutoresizingMaskIntoConstraints = false
        bd.setImage(UIImage(named: C.ImageName.trash.rawValue), for: .normal)
        return bd
    }()
    
    private let buttonEdit : UIButton = {
        let be = UIButton(frame: .zero)
        be.translatesAutoresizingMaskIntoConstraints = false
        be.setImage(UIImage(named: C.ImageName.edit.rawValue), for: .normal)
        return be
    }()
    private let buttonDone : UIButton = {
        let bd = UIButton(frame: .zero)
        bd.translatesAutoresizingMaskIntoConstraints = false
        bd.setImage(UIImage(named: C.ImageName.check.rawValue), for: .normal)
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
            self.buttonDone.setImage(UIImage(named:C.ImageName.undo.rawValue), for: .normal)
        }
        
        labelTaskName.text = detailModel.detailTaskVDM!.taskName
        textViewDescription.text = detailModel.detailTaskVDM!.taskDescription
        
    }
    
}
    
//MARK: - Set Up UI
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
        viewDetailHeightConstriant = viewDetail.heightAnchor.constraint(greaterThanOrEqualToConstant: 1)
        viewDetailHeightConstriant.isActive = true
        
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
            .bottomAnchor(margin: 16)
    
        textViewHeightConstraint = textViewDescription.heightAnchor.constraint(equalToConstant: 300)
        textViewHeightConstraint.isActive = true
        
        self.view.addSubview(viewBottom)
        viewBottom.leadingAnchor(margin: 0).trailingAnchor(margin: 0).bottomAnchor(margin: 0).heightAnchor(view.frame.width/6)
        
        let stackBottom = UIStackView.stackView(alignment: .fill, distribution: .fillEqually, spacing: 0, axis: .horizontal)
        viewBottom.addSubview(stackBottom)
        stackBottom.heightAnchor(60).leadingAnchor(margin: 0).trailingAnchor(margin: 0).topAnchor(margin: 0)
        
        viewBottom.taskDetailsShadow()
        
        let deleteButtonContainer = UIView.view().backgroundColor(.clear)
        let editButtonContainer = UIView.view().backgroundColor(.clear)
        let doneButtonContainer = UIView.view().backgroundColor(.clear)
        
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
        
        textViewDescription.textContainerInset = UIEdgeInsets.fill(with: -4)
        
        textViewDescription.sizeToFit()
        let sizeTv = textViewDescription.sizeThatFits(CGSize(width: viewDetail.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        print(textViewDescription)
        print(sizeTv)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil 
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
