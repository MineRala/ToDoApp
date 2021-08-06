//
//  CoreDataLayer.swift
//  ToDoApp
//
//  Created by Mine Rala on 4.08.2021.
//

import Foundation
import CoreData
import UIKit
import Combine

// MARK: - Core Data Response
struct CoreDataResponse {
    let error: AppError?
    let success: Bool
    let items: [ToDoItem]
}

// MARK: - Core Data Layer
class CoreDataLayer {
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private func save() -> AnyPublisher<CoreDataResponse, Never> {
        do{
            try CoreDataLayer.context.save()
            let response = CoreDataResponse(error: nil, success: true, items: [])
            return Just(response).eraseToAnyPublisher()
        }catch let error {
            NSLog("Core Data Error: \(error)")
            let response = CoreDataResponse(error: AppError.coreDataError, success: false, items: [])
            return Just(response).eraseToAnyPublisher()
        }
    }
    
    func getAllItems() -> AnyPublisher<CoreDataResponse, Never> {
        do{
            guard let items = try CoreDataLayer.context.fetch(ToDoItem.fetchRequest()) as? [ToDoItem] else {
                let response = CoreDataResponse(error: AppError.coreDataConvertingError, success: false, items: [])
                return Just(response).eraseToAnyPublisher()
            }
            let response = CoreDataResponse(error: nil, success: true, items: items)
            return Just(response).eraseToAnyPublisher()
        }catch let error {
            NSLog("Core Data Error: \(error)")
            let response = CoreDataResponse(error: AppError.coreDataError, success: false, items: [])
            return Just(response).eraseToAnyPublisher()
        }
        
    }
    
    func createItem(item: ToDoItem) -> AnyPublisher<CoreDataResponse, Never>{
        return save()
    }
    
    func deleteItem(item: ToDoItem) -> AnyPublisher<CoreDataResponse, Never>{
        CoreDataLayer.context.delete(item)
        return save()
    }
    
    func updateItem(item: ToDoItem) -> AnyPublisher<CoreDataResponse, Never> {
        return save()
    }
}
