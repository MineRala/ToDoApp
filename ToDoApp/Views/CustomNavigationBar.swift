//
//  CustomNavigationBar.swift
//  ToDoApp
//
//  Created by Mine Rala on 26.07.2021.
//

import Foundation
import UIKit
import DeclarativeUI
import DeclarativeLayout

protocol CustomNavigationBarDelegate {
    func customNavigationBarDidTappedLeftButton(_ navigationBar: CustomNavigationBar)
    func customNavigationBarDidTappedRightButton(_ navigationBar: CustomNavigationBar)
}

// MARK: - Skeleton
class CustomNavigationBar: UIView {
    
    private var delegate: CustomNavigationBarDelegate!
    
    private let lblTitle = UILabel
        .label()
        .alignment(.center)
        .font(C.Font.bold.font(20))
        .numberOfLines(1)
        .textColor(.white)
    
    private let btnRight = UIButton.button().backgroundColor(.clear).asButton()
    private let btnLeft = UIButton.button().backgroundColor(.clear).asButton()
    
    
    init(delegate: CustomNavigationBarDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Set Up UI
extension CustomNavigationBar {
    private func setUpUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)
        
        self.addSubview(self.lblTitle)
        self.lblTitle
            .centerXAnchor(margin: 0)
            .heightAnchor(24)
            .centerYAnchor(margin: 0)
        
        self.addSubview(self.btnLeft)
        self.btnLeft.leadingAnchor(margin: 16).dimensions(.init(width: 25, height: 25)).centerYAnchor(margin: 0)
        
        self.addSubview(self.btnRight)
        self.btnRight.trailingAnchor(margin: 16).dimensions(.init(width: 25, height: 25)).centerYAnchor(margin: 0)
        
        self.btnLeft.addTarget(self, action: #selector(btnLeftTapped), for: .touchUpInside)
        self.btnRight.addTarget(self, action: #selector(btnRightTapped), for: .touchUpInside)

    }
    
}

// MARK: - Actions
extension CustomNavigationBar {
    @objc private func btnLeftTapped() {
        self.delegate.customNavigationBarDidTappedLeftButton(self)
    }
    
    @objc private func btnRightTapped() {
        self.delegate.customNavigationBarDidTappedRightButton(self)
    }
}

// MARK: - Public
extension CustomNavigationBar {
    func setTitle(_ title: String) {
        self.lblTitle.text = title 
    }
    
    func setLeftButtonImage(_ image: UIImage?) {
        guard let image = image else {
            self.btnLeft.alpha = 0
            self.btnLeft.isEnabled = false
            return
        }
        self.btnLeft.setImage(image, for: .normal)
    }
    
    func setRightButtonImage(_ image: UIImage?) {
        guard let image = image else {
            self.btnRight.alpha = 0
            self.btnRight.isEnabled = false
            return
        }
        self.btnRight.setImage(image, for: .normal)
    }
}
