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

// MARK: - CoreDataManagableObject
protocol CoreDataManagableObject where Self: NSManagedObject {
    static var tableName: String { get }
}

// MARK: - Core Data Response
struct CoreDataResponse<T: CoreDataManagableObject> {
    let error: AppError?
    let success: Bool
    let items: [T]
    let savedItem: T?
}

// MARK: - Core Data Layer
class CoreDataLayer {
   
}

// NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
// MARK: - CRUD
extension CoreDataLayer {
    func update<T: CoreDataManagableObject>(_ item: T) -> AnyPublisher<CoreDataResponse<T>, Never> {
        return self.save(item)
    }
    
    func create<T: CoreDataManagableObject>(_ item: T) -> AnyPublisher<CoreDataResponse<T>, Never> {
        return self.save(item)
    }
    
    func remove<T: CoreDataManagableObject>(_ item: T) -> AnyPublisher<CoreDataResponse<T>, Never> {
        return self.delete(item)
    }
    
    
    private func delete<T: CoreDataManagableObject>(_ item: T) -> AnyPublisher<CoreDataResponse<T>, Never> {
        do {
            try ManagedObjectContext.delete(item)
            do{
                try ManagedObjectContext.save()
            } catch {
                NSLog("Error: \(error)")
                let response = CoreDataResponse<T>(error: AppError.coreDataError, success: false, items: [], savedItem: nil)
                return Just(response).eraseToAnyPublisher()
            }
            
            let response = CoreDataResponse<T>(error: nil, success: true, items: [], savedItem: item)
            return Just(response).eraseToAnyPublisher()
        } catch let error {
            NSLog("Error: \(error)")
            let response = CoreDataResponse<T>(error: AppError.coreDataError, success: false, items: [], savedItem: nil)
            return Just(response).eraseToAnyPublisher()
        }
    }
   
    
    func read<T: CoreDataManagableObject>(filterPredicate: NSPredicate? = nil) -> AnyPublisher<CoreDataResponse<T>, Never> {
        do {
            let fetchRequest = NSFetchRequest<T>(entityName: T.tableName)
            fetchRequest.predicate = filterPredicate
            let coreDataItems = try ManagedObjectContext.fetch(fetchRequest)
            let response = CoreDataResponse<T>(error: nil, success: true, items: coreDataItems, savedItem: nil)
            return Just(response).eraseToAnyPublisher()
        } catch let error {
            NSLog("Error: \(error)")
            let response = CoreDataResponse<T>(error: AppError.coreDataError, success: false, items: [], savedItem: nil)
            return Just(response).eraseToAnyPublisher()
        }
    }

    private func save<T: CoreDataManagableObject>(_ item: T) -> AnyPublisher<CoreDataResponse<T>, Never> {
        do {
            try ManagedObjectContext.save()
            let response = CoreDataResponse<T>(error: nil, success: true, items: [], savedItem: item)
            return Just(response).eraseToAnyPublisher()
        } catch let error {
            NSLog("Error: \(error)")
            let response = CoreDataResponse<T>(error: AppError.coreDataError, success: false, items: [], savedItem: nil)
            return Just(response).eraseToAnyPublisher()
        }
    }
    
    
}
