//
//  CoreDataLayer.swift
//  ToDoApp
//
//  Created by Mine Rala on 4.08.2021.
//

import Foundation
import  CoreData
import  UIKit

class CoreDataLayer {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private func save(){
        do{
            try context.save()
        }catch{
            
        }
    }
    
    func getAllItems() -> [ToDoItem] {
        do{
            return try context.fetch(ToDoItem.fetchRequest())
        }catch{
            return []
        }
        
    }
    
    func createItem(item: ToDoItem){
        save()
    }
    
    func deleteItem(item: ToDoItem){
        context.delete(item)
        save()
    }
    
    func updateItem(item: ToDoItem){
        save()
    }
}
