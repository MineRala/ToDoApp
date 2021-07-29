//
//  TaskDetailsViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 29.07.2021.
//

import Foundation
import  UIKit

class TaskDetailsViewController : BaseVC {
   
    private let stackBottom = UIStackView.stackView(alignment: .fill, distribution: .fillEqually, spacing: 8, axis: .horizontal)
    
    
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
        vd.layer.cornerRadius = 10
        vd.taskDetailsShadow()
        return vd
    }()
    
    private let labelTaskName: UILabel = {
        let ltn = UILabel(frame: .zero)
        ltn.translatesAutoresizingMaskIntoConstraints = false
        ltn.text = "Meet Joshoep"
        ltn.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        ltn.font = UIFont(name: "Roboto-Medium", size: 20)
        return ltn
    }()
    
    private let labelDate: UILabel = {
        let ld = UILabel(frame: .zero)
        ld.translatesAutoresizingMaskIntoConstraints = false
        ld.text = "27 Feb, 2018 | 04:00 PM"
        ld.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        ld.font = UIFont(name: "Roboto-Regular", size: 16)
        return ld
    }()
    
    private let textViewDescription : UITextView = {
        let tvd = UITextView(frame: .zero)
        tvd.translatesAutoresizingMaskIntoConstraints = false
        tvd.text = "Have to meet him because i want to show him my latest app design in person.  Also need to ask for advice on these:  - style - interaction - copy .Have to meet him because i want to show him my latest app design in person.  Also need to ask for advice on these:  - style - interaction - copy.Have to meet him because i want to show him my latest app design in person.  Also need to ask for advice on these:  - style - interaction - copy.Have to meet him because i want to show him my latest app design in person.  Also need to ask for advice on these:  - style - interaction - copy."
        tvd.textColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        tvd.font = UIFont(name: "Roboto-Regular", size: 16)
        tvd.isEditable = false
        tvd.isScrollEnabled = true
        return tvd
    }()

    
    private let buttonDelete : UIButton = {
        let bd = UIButton(frame: .zero)
        bd.translatesAutoresizingMaskIntoConstraints = false
        bd.setImage(UIImage(named: "TrashIcon"), for: .normal)
       // bd.frame.size = CGSize(width: 4, height: 4)
        return bd
    }()
    
    private let buttonEdit : UIButton = {
        let be = UIButton(frame: .zero)
        be.translatesAutoresizingMaskIntoConstraints = false
        be.setImage(UIImage(named: "EditIcon"), for: .normal)
        return be
    }()
    private let buttonDone : UIButton = {
        let bd = UIButton(frame: .zero)
        bd.translatesAutoresizingMaskIntoConstraints = false
        bd.setImage(UIImage(named: "CheckIcon"), for: .normal)
        return bd
    }()
    
    private let viewForButton : UIView = {
        let vfb = UIView(frame: .zero)
        vfb.translatesAutoresizingMaskIntoConstraints = false
        vfb.backgroundColor = .orange
        return vfb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)
        setUpUI()
    }
    
    
    private func setUpUI() {
        
        self.view.addSubview(viewContinue)
        viewContinue.topAnchor(margin: C.navigationBarHeight + C.statusBarHeight)
            .leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .heightAnchor(76)
        
        self.view.addSubview(viewDetail)
        viewDetail.topAnchor.constraint(equalTo: viewContinue.topAnchor, constant: 16).isActive = true
        viewDetail.leadingAnchor(margin: 20).trailingAnchor(margin: 20)
        viewDetail.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.4).isActive = true
        
        self.viewDetail.addSubview(labelTaskName)
        labelTaskName.topAnchor.constraint(equalTo: viewDetail.topAnchor, constant: 36).isActive = true
        labelTaskName.leadingAnchor.constraint(equalTo: viewDetail.leadingAnchor, constant: 16).isActive = true
        labelTaskName.trailingAnchor.constraint(equalTo: viewDetail.trailingAnchor, constant: -16).isActive = true
        labelTaskName.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        self.viewDetail.addSubview(labelDate)
        labelDate.topAnchor.constraint(equalTo: labelTaskName.bottomAnchor, constant: 16).isActive = true
        labelDate.leadingAnchor.constraint(equalTo: viewDetail.leadingAnchor, constant: 16).isActive = true
        labelDate.trailingAnchor.constraint(equalTo: viewDetail.trailingAnchor, constant: -16).isActive = true
        labelDate.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        self.viewDetail.addSubview(textViewDescription)
        textViewDescription.topAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 16).isActive = true
        textViewDescription.leadingAnchor.constraint(equalTo: viewDetail.leadingAnchor, constant: 16).isActive = true
        textViewDescription.trailingAnchor.constraint(equalTo: viewDetail.trailingAnchor, constant: -16).isActive = true
        textViewDescription.bottomAnchor.constraint(equalTo: viewDetail.bottomAnchor, constant: -16).isActive = true

        
        self.view.addSubview(stackBottom)
        
        stackBottom.backgroundColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        stackBottom.taskDetailsShadow()
        
        stackBottom.addArrangedSubview(buttonDelete)
        stackBottom.addArrangedSubview(buttonEdit)
        stackBottom.addArrangedSubview(buttonDone)
        
        stackBottom.leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .heightAnchor(view.frame.width/7)
        
        stackBottom.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        
        buttonDelete.addTarget(nil, action: #selector(deleteButtonTapped), for: UIControl.Event.touchUpInside)
        buttonEdit.addTarget(nil, action: #selector(editButtonTapped), for: UIControl.Event.touchUpInside)
        buttonDone.addTarget(nil, action: #selector(doneButtonTapped), for: UIControl.Event.touchUpInside)
    }
    
    @objc func deleteButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func editButtonTapped() {
        let vc = SelectDateViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func doneButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
