//
//  Alerts.swift
//  ToDoApp
//
//  Created by Mine Rala on 3.08.2021.
//

import Foundation
import UIKit

class Alerts : NSObject {
    
    func showAlertDelete(controller: UIViewController, _ message: String, deletion: @escaping () -> Void) {
        let dialogMessage = UIAlertController(title: "Deletion Confirmation", message: message, preferredStyle: .alert)
        dialogMessage.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            deletion()
        }))
        dialogMessage.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
           print("cancel is tapped.")
        }))
        controller.present(dialogMessage, animated: true, completion: {})
    }
}
