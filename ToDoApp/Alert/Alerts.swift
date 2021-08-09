//
//  Alerts.swift
//  ToDoApp
//
//  Created by Mine Rala on 3.08.2021.
//

import Foundation
import UIKit

class Alerts : NSObject {
    
   static func showAlertDelete(controller: UIViewController, _ message: String, deletion: @escaping () -> Void) {
        let dialogMessage = UIAlertController(title: NSLocalizedString("Deletion Confirmation", comment: ""), message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .default, handler: { (action) in
        deletion()
        })
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        dialogMessage.addAction(deleteAction)
   
        dialogMessage.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) in
           print("cancel is tapped.")
        }))
        controller.present(dialogMessage, animated: true, completion: {})
    }
}
