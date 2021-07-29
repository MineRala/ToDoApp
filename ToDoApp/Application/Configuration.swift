//
//  Configuration.swift
//  ToDoApp
//
//  Created by Aybek Can Kaya on 27.07.2021.
//

import Foundation
import UIKit

var KeyWindow : UIWindow {UIApplication.shared.windows.first(where: { $0.isKeyWindow })! }

struct C {

    static var statusBarHeight: CGFloat { UIDevice.current.hasNotch ? 47 : 22 }
    static var navigationBarHeight: CGFloat = 44
    
    enum Font: String {
        case bold = "Roboto-Bold"
        case medium = "Roboto-Medium"
        case light = "Roboto-Light"
        case regular = "Roboto-Regular"
        
        func font(_ size: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: size)!
        }
    }
}
