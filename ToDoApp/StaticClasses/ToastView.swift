//
//  ToastView.swift
//  ToDoApp
//
//  Created by Mine Rala on 17.08.2021.
//

import Foundation
import UIKit

class ToastView: UIView {
    
    private var message: String = ""
    private let lblToast: UILabel = {
        let toastLbl = UILabel()
        toastLbl.translatesAutoresizingMaskIntoConstraints = false
        toastLbl.textAlignment = .center
        toastLbl.font = C.Font.medium.font(20)
        toastLbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        toastLbl.backgroundColor = .clear
        toastLbl.numberOfLines = 0
        return toastLbl
    }()
    
    init(message: String) {
        super.init(frame: .zero)
        self.message = message
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Set Up UI
extension ToastView {
    private func setUpUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.8)
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
        self.selectDateShadow()
        
        self.addSubview(self.lblToast)
        
        self.lblToast.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        self.lblToast.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        self.lblToast.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        self.lblToast.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        self.lblToast.text = message
        
        self.alpha = 1
        self.lblToast.backgroundColor = .clear
    }
}

// MARK: - Public
extension ToastView {
    static func show(with message: String) {
        guard let window = UIApplication.shared.keyWindow else { return }
        let toastView = ToastView(message: message)
        window.addSubview(toastView)
        toastView.centerXAnchor.constraint(equalTo: window.centerXAnchor, constant: 0).isActive = true
        toastView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -64).isActive = true
        toastView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        toastView.heightAnchor.constraint(equalToConstant: 84).isActive = true
        toastView.alpha = 1.0
        UIView.animate(withDuration: 4.0, delay: 0, options: .curveEaseInOut) {
           toastView.alpha = 0
        } completion: { _ in
           toastView.removeFromSuperview()
        }
    }
}
