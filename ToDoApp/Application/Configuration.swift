//
//  Configuration.swift
//  ToDoApp
//
//  Created by Aybek Can Kaya on 27.07.2021.
//

import Foundation
import UIKit
import CoreData

var KeyWindow : UIWindow { UIApplication.shared.windows.first(where: { $0.isKeyWindow })! }
var ManagedObjectContext: NSManagedObjectContext  { (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext }

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
    
    enum ImageName : String {
       case undo = "undoGray"
       case trash = "TrashIcon"
       case edit = "EditIcon"
       case check = "CheckIcon"
        
    }
    
}
