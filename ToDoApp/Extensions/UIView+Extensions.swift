//
//  UIView+Extensions.swift
//  ToDoApp
//
//  Created by Mine Rala on 29.07.2021.
//

import Foundation
import UIKit

extension UIView {
    
//MARK: - Task Detail Shadow
    func taskDetailsShadow() {
        self.layer.shadowColor = C.BackgroundColor.shadowColor.withAlphaComponent(0.1).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 20
        self.layer.shouldRasterize = true
        self.layer.masksToBounds = false
    }
//MARK: - Select Date Shadow
    func selectDateShadow() {
        self.layer.shadowColor = C.BackgroundColor.shadowColor.withAlphaComponent(0.1).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 20
        self.layer.shouldRasterize = true
        self.layer.masksToBounds = false
    }
    
}
