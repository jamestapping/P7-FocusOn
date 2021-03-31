//
//  DateManager.swift
//  FocusOn
//
//  Created by James Tapping on 30/03/2021.
//

import Foundation

class DateManager {
    
    var today: Date {
          return startOfDay(for: Date())
      }
      
      func startOfDay(for date: Date) -> Date {
          var calendar = Calendar.current
          calendar.timeZone = TimeZone.current
          return calendar.startOfDay(for: date) // eg. yyyy-mm-dd 00:00:00
      }
    
}
