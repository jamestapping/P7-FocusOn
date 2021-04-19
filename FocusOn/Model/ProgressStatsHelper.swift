//
//  ProgressStatsHelper.swift
//  FocusOn
//
//  Created by James Tapping on 19/04/2021.
//

import Foundation

class ProgressStatsHelper {

let dataManager = DataManager()

func dataForYear(year: Date) -> [(completed: Int, total: Int)] {
          var data = [(completed: Int, total: Int)]()
          let year = Calendar.current.component(.year, from: year)
          for i in 1 ... 12 {
              let firstDayOfMonth = Calendar.current.date(from: DateComponents(year: year, month: i, day: 1))!
              let lastDayComponents = DateComponents(month: 1, day: -1)
              let lastDayOfMonth = Calendar.current.date(byAdding: lastDayComponents, to: firstDayOfMonth)!
              data.append(dataForDates(first: firstDayOfMonth, last: lastDayOfMonth))
          }
          return data
  }


func dataForDates(first: Date, last: Date) -> (Int, Int) {
          let goals = dataManager.returnGoalsBetweenDate(from: first, to: last)
          let goalsCompleted =  goals.filter { (goal) -> Bool in
              return goal.completed == true
          }.count
    
          return (goalsCompleted, goals.count)
      }

}
