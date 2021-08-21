//
//  NotificationPickerToolBar.swift
//  ToDoApp
//
//  Created by Mine Rala on 12.08.2021.
//

import Foundation
import UIKit

class ToolbarPickerView: UIPickerView {

    private(set) var toolbar: UIToolbar?
    var toolbarDelegate: AddActionsInPickerViewNewAndEditViewControllerDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: - Common Init
extension ToolbarPickerView {
    private func commonInit() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .black
        toolBar.isTranslucent = true
        toolBar.tintColor = C.BackgroundColor.toolBarTintColor
        toolBar.layer.backgroundColor = C.BackgroundColor.toolBarBackgroundColor.cgColor
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
    }
}

//MARK: - Done And Cancel Button Tapped
extension ToolbarPickerView {
    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone()
    }

    @objc func cancelTapped() {
        self.toolbarDelegate?.didTapCancel()
    }
}
