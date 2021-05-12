//
//  ProgressStatsHelper.swift
//  FocusOn
//
//  Created by James Tapping on 19/04/2021.
//

import Foundation

class ProgressStatsHelper {
    
    let dataManager = DataManager()
    let dateManager = DateManager()
    var modifiedDate = Date()
    
    func returnYearData(year: Date) -> [(completed: Int, total: Int)] {
        var data = [(completed: Int, total: Int)]()
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: year)
        
        for i in 1 ... 12 {
            let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: i, day: 1))!
            let lastDayComponent = DateComponents(month: 1, day: -1)
            let lastDayOfMonth = calendar.date(byAdding: lastDayComponent, to: firstDayOfMonth)!
            data.append(returnDataBetweenDates(first: firstDayOfMonth, last: lastDayOfMonth))
        }
        return data
    }
    
    
    func returnWeekData(week: Date) -> [(completed: Int, total: Int)] {
        let firstDayOfWeek = dateManager.firstDayOfWeek(for: week)
        let lastDayOfWeek = firstDayOfWeek.addingTimeInterval(TimeInterval(6 * 24 * 3600))
        return goalDataForDates(first: firstDayOfWeek, last: lastDayOfWeek)
    }
    
    func returnMonthData(date: Date) -> [(completed: Int, total: Int)] {
        
        let firstDayOfMonth = dateManager.firstDayOfMonth(for: date)
        let lastDayOfMonth = dateManager.lastDayOfMonth(for: date)
        
        return goalDataForMonth(first: firstDayOfMonth, last: lastDayOfMonth)
    }
    
    func goalDataForMonth(first: Date, last: Date) -> [(completed: Int, total: Int)] {
        
        let numberOfDaysInMonth = dateManager.numberOfDaysInMonth(date: first)
        var data = [(completed: Int, total: Int)]()
        let goals = dataManager.returnGoalsBetweenDate(from: first, to: last)
        
        var completed = 0
        var total = 0
        var date = first
        
        for _ in 1 ... numberOfDaysInMonth {
            
            let goalsForDate = goals.filter { $0.date == dateManager.startOfDay(for: date) }
            
            // print ("Found", goalsForDate.count, "for date", dateManager.startOfDay(for: date))
            
            if goalsForDate.count > 0 {
                completed = goalsForDate.filter { $0.completed == true }.count
                total = goalsForDate.count
                data.append((completed: completed, total: total))
                
            } else {
                
                data.append((completed: 0, total: 0))
                
            }
            
            date.addTimeInterval(Double(3600 * 24))
        }
        return data
    }
    
    func goalDataForDates(first: Date, last: Date) -> [(completed: Int, total: Int)] {
        var data = [(completed: Int, total: Int)]()
        let goals = dataManager.returnGoalsBetweenDate(from: first, to: last)
        
        var completed = 0
        var total = 0
        var date = first
        for _ in 1 ... 7 {
            let goalsForDate = goals.filter { $0.date == dateManager.startOfDay(for: date) }
            
            if goalsForDate.count > 0 {
                completed = goalsForDate.filter { $0.completed == true }.count
                total = goalsForDate.count
                data.append((completed: completed, total: total))
                
            } else {
                
                data.append((completed: 0, total: 0))
                
            }
            
            date.addTimeInterval(Double(3600 * 24))
        }
        return data
    }
    
    func returnDataBetweenDates(first: Date, last: Date) -> (Int, Int) {
        
        let goals = dataManager.returnGoalsBetweenDate(from: first, to: last)
        let completedGoals = goals.filter { $0.completed == true }.count
        
        return (completedGoals, goals.count)
    }
    
    
    func buildFirstDayOfWeekLabel(date: Date) -> String {
        
        let firstDayOfWeek = dateManager.firstDayOfWeek(for: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: firstDayOfWeek)
        
        return formattedDate
    }
    
    
    func buildYearLabel(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy"
        
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
        
    }
    
    func buildFirstDayOfMonthLabel(date:Date) -> String {
        
        let firstDayOfTheMonth = dateManager.firstDayOfMonth(for: date)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM yyyy"
        
        let formattedDate = dateFormatter.string(from: firstDayOfTheMonth)
        
        return formattedDate
        
    }
    
}

