//
//  SelectDateViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 29.07.2021.
//

import Foundation
import UIKit



class SelectDateViewController : BaseVC{
    
    private let calendarVCContainer = UIView.view().backgroundColor(.blue)
    //private let calendarVC : CalendarViewController = CalendarViewController()
        
    private let timeView: UIView = {
        let tv = UIView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tv.taskDetailsShadow()
        return tv
    }()
    
    private let itemContainerView : UIView = {
        let icv = UIView(frame: .zero)
        icv.translatesAutoresizingMaskIntoConstraints = false
        icv.backgroundColor = .clear
        return icv
    }()
    
    private let selectButton : UIButton = {
        let sb = UIButton(frame: .zero)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)
        sb.setTitle(NSLocalizedString("Select", comment: ""), for: .normal)
        sb.titleLabel?.font = C.Font.medium.font(21)
        return sb
    }()
}

//MARK: - Lifecycle
extension SelectDateViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}
    
//MARK: - Set Up UI
extension SelectDateViewController{
    private func setUpUI(){
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
      //  self.addChildViewController(childController: calendarVC, onView: calendarVCContainer)
 
        self.itemContainerView.addSubview(timeView)
        self.itemContainerView.addSubview(selectButton)
        
        timeView.topAnchor.constraint(equalTo: calendarVCContainer.bottomAnchor, constant: 24).isActive = true
        timeView.leadingAnchor(margin: 24)
            .trailingAnchor(margin: 24)

        selectButton.bottomAnchor(margin: 0)
            .leadingAnchor(margin: 0)
            .trailingAnchor(margin: 0)
            .heightAnchor(view.frame.width/5)
    
        timeView.bottomAnchor.constraint(equalTo: selectButton.topAnchor, constant: -24).isActive = true
        
        selectButton.addTarget(nil, action: #selector(selectButtonTapped), for: .touchUpInside)
       
    }
}
//MARK: - Actions
extension SelectDateViewController {
    @objc func selectButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
}
   
    

