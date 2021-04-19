//
//  ProgressStatsHelper.swift
//  FocusOn
//
//  Created by James Tapping on 19/04/2021.
//

import Foundation

class ProgressStatsHelper {

let dataManager = DataManager()

    func returnYearData(year: Date) -> [(completed: Int, total: Int)] {
        var data = [(completed: Int, total: Int)]()
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: year)
        
        for i in 1 ... 12 {
            let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: i, day: 1))!
            let lastDayComponents = DateComponents(month: 1, day: -1)
            let lastDayOfMonth = calendar.date(byAdding: lastDayComponents, to: firstDayOfMonth)!
            data.append(returnDataBetweenDates(first: firstDayOfMonth, last: lastDayOfMonth))
        }
        return data
    }

func returnDataBetweenDates(first: Date, last: Date) -> (Int, Int) {
    
          let goals = dataManager.returnGoalsBetweenDate(from: first, to: last)
          let completedGoals = goals.filter { $0.completed == true }.count
    
          return (completedGoals, goals.count)
      }

}

