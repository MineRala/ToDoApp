//
//  CalendarViewController.swift
//  ToDoApp
//
//  Created by Mine Rala on 28.07.2021.
//

import Foundation
import UIKit
import FSCalendar
import Combine

// MARK: - Calendar View Controller
class CalendarViewController : UIViewController{
    private let calendar = FSCalendar()
    private var date: Date?
    private(set) var selectedDate = CurrentValueSubject<Date, Never>(Date())
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        self.cancellables.forEach { $0.cancel() }  
    }
}

// MARK: - Lifecycle
extension CalendarViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

// MARK: - Set Up UI
extension CalendarViewController {
    func setUpUI() {
        view.addSubview(calendar)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.fit()
        
        calendar.appearance.titleFont = C.Font.medium.font(14)
        calendar.appearance.weekdayFont = C.Font.medium.font(16)
        calendar.appearance.weekdayTextColor = C.BackgroundColor.weekdayTextColor
        calendar.appearance.todayColor = C.BackgroundColor.clearColor
        calendar.appearance.titleTodayColor = C.BackgroundColor.titleTodayColor
        calendar.appearance.selectionColor = C.BackgroundColor.selectionColor
        calendar.appearance.headerTitleColor = C.BackgroundColor.headerTitleColor
        
        calendar.delegate = self
        
        if date == nil {
            self.setDateToCalendar(date: Date())
        }
        else{
            self.setDateToCalendar(date: date!)
        }
    }
    
    func changeSelectionColor(to color: UIColor) {
        self.calendar.appearance.selectionColor = color
    }
}

// MARK: - Public
extension CalendarViewController {
    func selectDate(_ date: Date) {
        self.selectedDate.send(date)
        self.calendar.select(date)
    }
    
    func setDateToCalendar(date: Date){
        self.calendar.select(date)
    }
   
    func getSelectedDate() -> Date {
        return self.calendar.selectedDate!
    }
    
}
   
// MARK: - FSCalendar Delegate / Datasource
extension CalendarViewController: FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        let newMinDate = calendar.currentPage
//        let newMaxDate = calendar.currentPage + Date.numberOfDays(in: Int(calendar.currentPage.month), year: Int(calendar.currentPage.year)).days
//        viewModel.updateVisibleDateRange(min: newMinDate, max: newMaxDate)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectDate(date)
    }
}

//MARK: - Set Date
extension CalendarViewController {
    func setDate(date: Date){
        self.date = date
    }
}
