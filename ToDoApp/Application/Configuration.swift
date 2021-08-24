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
    
    enum Font : String {
        case bold = "Roboto-Bold"
        case medium = "Roboto-Medium"
        case light = "Roboto-Light"
        case regular = "Roboto-Regular"
        
        func font(_ size: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: size)!
        }
    }

    struct ImageIcon {
        static var addIcon: UIImage {#imageLiteral(resourceName: "AddIcon")}
        static var backIcon: UIImage {#imageLiteral(resourceName: "BackIcon")}
        static var checkIcon: UIImage {#imageLiteral(resourceName: "CheckIcon")}
        static var deleteIcon: UIImage {#imageLiteral(resourceName: "DeleteIcon")}
        static var doneIcon: UIImage {#imageLiteral(resourceName: "DoneIcon")}
        static var editIcon: UIImage {#imageLiteral(resourceName: "EditIcon")}
        static var searchIcon: UIImage {#imageLiteral(resourceName: "SearchIcon")}
        static var trashIcon: UIImage {#imageLiteral(resourceName: "TrashIcon")}
        static var undoIcon: UIImage {#imageLiteral(resourceName: "undoGray")}
    }
    
    struct BackgroundColor {
        static var clearColor: UIColor {UIColor.clear}
        static var searchVCContainerBackgroundColor: UIColor {#colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)}
        static var calendarVCContainerBackgroundColor: UIColor {#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)}
        static var eventVCContainerBackgroundColor: UIColor {#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)}
        static var editingColor: UIColor {UIColor.black}
        static var defaultColor: UIColor {UIColor.lightGray}
        static var floatingTextFieldBackgroundColor: UIColor {#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)}
        static var addButtonBackgroundColor: UIColor {#colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)}
        static var addButtonSetTitleColor: UIColor {#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)}
        static var addButtonTintColor: UIColor {UIColor.white}
        static var newAndEditViewBackgroundColor: UIColor {#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)}
        static var notificationPicerViewBackgroundColor: UIColor {#colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)}
        static var notificationPicerViewSetValueColor: UIColor {UIColor.white}
        static var stackViewBackgroundColor: UIColor {#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)}
        static var viewTopBackgroundColor: UIColor {#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)}
        static var viewBackgroundColor: UIColor {#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)}
        static var viewBottomBackgroundColor: UIColor {#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)}
        static var viewContinueBackgroundColor: UIColor {#colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)}
        static var viewDetailBackgroundColor: UIColor {#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)}
        static var labelDateTextColor: UIColor {#colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)}
        static var textViewDescriptionTextColor: UIColor {#colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 0.75)}
        static var timeViewBackgroundColor: UIColor {#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)}
        static var selectButtonBackgroundColor: UIColor {#colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)}
        static var selectDateViewBackgroundColor: UIColor {#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)}
        static var changeSelectionPastDateColor: UIColor {#colorLiteral(red: 0.462745098, green: 0.3829472341, blue: 0.6060211804, alpha: 1)}
        static var changeSelectionColor: UIColor {#colorLiteral(red: 0.462745098, green: 0.2745098039, blue: 1, alpha: 1)}
        static var searchViewBackgroundColor: UIColor {#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)}
        static var searchTextFieldBackgroundColor: UIColor {#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)}
        static var weekdayTextColor: UIColor {#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.75)}
        static var titleTodayColor: UIColor {UIColor.black}
        static var selectionColor: UIColor {#colorLiteral(red: 0.462745098, green: 0.2745098039, blue: 1, alpha: 1)}
        static var headerTitleColor: UIColor {#colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)}
        static var trashBackgroundColor: UIColor {#colorLiteral(red: 1, green: 0.2571013272, blue: 0.3761356473, alpha: 1)}
        static var doneBackgroundColor: UIColor {#colorLiteral(red: 0.2980392157, green: 0.7960784314, blue: 0.2549019608, alpha: 1)}
        static var toolBarTintColor: UIColor {#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)}
        static var toolBarBackgroundColor: UIColor {#colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)}
        static var deleteActionColor: UIColor {UIColor.red}
        static var okActionColor: UIColor {UIColor.blue}
        static var noActionColor: UIColor {UIColor.red}
        static var toastLabelTextColor: UIColor {#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)}
        static var toastViewBackgroundColor: UIColor {#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)}
        static var shadowColor: UIColor {UIColor.black}
        static var viewStatusBackgroundColor: UIColor {#colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)}
        static var baseVCBackgroundColor: UIColor {#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)}
        static var labelTitleTextColor: UIColor {UIColor.white}
        static var customNavigationBarBackgroundColor: UIColor {#colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)}
        static var hourLabelTextColor: UIColor {#colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)}
        static var hourPeriodLabelTextColor: UIColor {#colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)}
        static var taskNameTextColor: UIColor {#colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)}
        static var taskCategoryTextColor: UIColor {#colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)}
        static var dayLabelTextColor: UIColor {#colorLiteral(red: 0.3764705882, green: 0.2078431373, blue: 0.8156862745, alpha: 1)}
        static var contentViewBackgroundColor: UIColor {#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)}
    }
}
