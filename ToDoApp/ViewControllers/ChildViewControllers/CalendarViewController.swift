//
//  CalendarViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 28.07.2021.
//

import Foundation
import UIKit

class CalendarViewController : UIViewController{

    private let calenderView : UIView = {
        let cv = UIView(frame: .zero)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
}

//MARK: - Lifecycle
extension CalendarViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}
    
//MARK: - Set Up UI
extension CalendarViewController {
    func setUpUI() {
        self.view.addSubview(calenderView)
    }
}
   
