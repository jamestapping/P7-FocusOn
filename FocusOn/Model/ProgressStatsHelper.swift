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
        let firstDayOfweek = dateManager.firstDayOfWeek(for: week)
        let lastDayOfWeek = firstDayOfweek.addingTimeInterval(TimeInterval(6 * 24 * 3600))
        return goalDataForDates(first: firstDayOfweek, last: lastDayOfWeek)
    }
    
    func goalDataForDates(first: Date, last: Date) -> [(completed: Int, total: Int)] {
        var data = [(completed: Int, total: Int)]()
        let goals = dataManager.returnGoalsBetweenDate(from: first, to: last)
        
        print ("Got", goals.count, " goals")
        
        print(goals[0].date as Any)
        
        var completed = 0
        var total = 0
        var date = first
        for _ in 1 ... 7 {
            let goalsForDate = goals.filter { $0.date == dateManager.startOfDay(for: date) }
            
            print ("Found", goalsForDate.count, "for date", dateManager.startOfDay(for: date))
            
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
    
}

