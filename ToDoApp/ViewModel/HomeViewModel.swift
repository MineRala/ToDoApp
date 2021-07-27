//
//  HomeViewModel.swift
//  ToDoApp
//
//  Created by Aybek Can Kaya on 27.07.2021.
//

import Foundation
import Combine
import Debouncer

struct TaskVDM {
    var title: String
    var hourStr: String
    var amPmSymbol: String
}

class Task {
    var name: String = ""
}

class HomeViewModel {
    private(set) var searchText = CurrentValueSubject<String, Never>("")
    private(set) var arrTasks = CurrentValueSubject<[Task], Never>([])
    private let debouncer = Debouncer(timeInterval: 0.3)
    
    
    
    func updateSearchText(_ text: String) {
        debouncer.ping()
        debouncer.tick {
            self.searchText.send(text)
        }
    }
}
