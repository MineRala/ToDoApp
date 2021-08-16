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
    private let viewModel: HomeViewModel
    private var date: Date?
    private(set) var selectedDate = CurrentValueSubject<Date,Never>(Date())

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        calendar.appearance.weekdayTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.75)
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.selectionColor = #colorLiteral(red: 0.462745098, green: 0.2745098039, blue: 1, alpha: 1)
        calendar.appearance.headerTitleColor = #colorLiteral(red: 0.09019607843, green: 0.1529411765, blue: 0.2078431373, alpha: 1)
        
        calendar.delegate = self
        
        if date == nil {
            self.setDateToCalendar(date: Date())
        }
        else{
            self.setDateToCalendar(date: date!)
        }
    }
}

// MARK: - Public
extension CalendarViewController {
    func selectDate(_ date: Date) {
        selectedDate.send(date)
        if date < Date() {
            print(date)
            print(Date())
            Alerts.showAlert(controller: self, "You cannot select date from past") {}
        }else{
            self.calendar.select(date)
            self.viewModel.updateSelectedDate(date)
        }

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
        let newMinDate = calendar.currentPage
        let newMaxDate = calendar.currentPage + Date.numberOfDays(in: Int(calendar.currentPage.month), year: Int(calendar.currentPage.year)).days
        viewModel.updateVisibleDateRange(min: newMinDate, max: newMaxDate)
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
