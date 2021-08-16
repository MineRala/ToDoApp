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
    private(set) var selectedDate = CurrentValueSubject<Date, Never>(Date())
    private var cancellables = Set<AnyCancellable>()
    private var pickerDate : Date?
    
    // Store hours and minutes here so you will be able to use it whenever you need
    // Also it will be updated when picker has changed its value.
    
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
    
// MARK: - Listeners
extension CalendarViewController {
    func addListeners() {
        self.selectedDate
            .receive(on: DispatchQueue.main)
            .sink { selectedDate in
                self.setPickerDate(pickerDate: selectedDate)
                let dateGMT = Date().toGMTFromLocal()
                if self.date!.year <= dateGMT.year && self.date!.month <= dateGMT.month  && self.date!.day <= dateGMT.day &&  selectedDate.hour <= self.date!.hour && selectedDate.minute <= self.date!.minute {
                    print("Selected invalid time. point 2")
                    self.calendar.appearance.selectionColor = #colorLiteral(red: 0.462745098, green: 0.4910603364, blue: 1, alpha: 1)
                }
            }.store(in: &cancellables)
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
            addListeners()
        }
    }
}

// MARK: - Public
extension CalendarViewController {
    func selectDate(_ date: Date) {
        print(date)
        if pickerDate == nil {          // If Calender is in the HomeViewController
            self.calendar.select(date)
            self.viewModel.updateSelectedDate(date)
            return
        }
        let currentDate = Date().toGMTFromLocal()
        if date > currentDate {
            self.calendar.select(date)
            self.viewModel.updateSelectedDate(date)
            return
        }
        if date.day != currentDate.day {
            Alerts.showAlert(controller: self, "You cannot select date from past") {}
            return
        }
        if pickerDate!.hour < currentDate.hour {
            Alerts.showAlert(controller: self, "You cannot select date from past") {}
            return
        }
        else if pickerDate!.hour > currentDate.hour {
            self.calendar.select(date)
            self.viewModel.updateSelectedDate(date)
            return
        }
        if pickerDate!.minute <= currentDate.minute {
            Alerts.showAlert(controller: self, "You cannot select date from past") {}
            return
        }
        self.calendar.select(date)
        self.viewModel.updateSelectedDate(date)
    }
    
    func setPickerDate(pickerDate: Date) {
        self.pickerDate = pickerDate
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
        // add hours and minutes(date) from SelectedDateViewController to the date (integration of hours and minutes)
        selectDate(date)
    }
}

//MARK: - Set Date
extension CalendarViewController {
    func setDate(date: Date){
        self.date = date
        
    }
}


extension Date {
    func isDateEarlierInHoursAndMinutes(hourDate: Date) -> Bool {
        if self.hour <= hourDate.hour && self.minute < hourDate.minute {
            return true
        }
        return false
    }
    
    func isDateEarlierInDays(dayDate: Date) -> Bool {
        if self.day <= dayDate.day && self.month <= dayDate.month && self.year <= dayDate.year {
            return true
        }
        return false
    }
}
