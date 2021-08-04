//
//  HomeViewModel.swift
//  ToDoApp
//
//  Created by Aybek Can Kaya on 27.07.2021.
//

import Foundation
import Combine

class HomeViewModel {

    private(set) var searchText = CurrentValueSubject<String, Never>("")
    private(set) var arrTasks = CurrentValueSubject<[TaskCellViewDataModel], Never>([])
    
    private var myList: [TaskModel] = []
}
