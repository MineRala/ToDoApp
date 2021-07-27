//
//  UIDevice+Extensions.swift
//  ToDoApp
//
//  Created by Aybek Can Kaya on 27.07.2021.
//

import Foundation
import UIKit

// MARK: - UIDevice Extension
extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            return KeyWindow.safeAreaInsets.bottom != 0
        }
        return false
    }
}
