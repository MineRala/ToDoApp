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
   
    private var models =  [ToDoItem]()
    
    func getAllItems() -> [ToDoItem]? {
        do{
        return try context.fetch(ToDoItem.fetchRequest())
        }catch{
            return nil 
}
        
    }
    
    func createItem(taskName: String , taskDescription: String){
        let newTaskItem = ToDoItem(context: context)
        newTaskItem.taskName = taskName
        newTaskItem.taskDescription = taskDescription
        
        do{
            try context.save()
            getAllItems()
        }catch{
            
        }
        
    }
    
    func deleteItem(item: ToDoItem){
        context.delete(item)
        do{
            try context.save()
            getAllItems()
        }catch{
            
        }
    }
    
    func updateItem(item: ToDoItem ,newName: String, newDescription: String){
        item.taskName = newName
        item.taskDescription = newDescription          
        do{
            try context.save()
            getAllItems()   
        }catch{
            
        }
}
    }
