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
        let calendar = Calendar.current
        let returnDate = calendar.startOfDay(for: date)
        return returnDate
    }
    
    func dateAsString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = date.dateFormatWithSuffix()
        return dateFormatter.string(from: date)
    }
    
    func firstDayOfWeek(for date: Date) -> Date{
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let difference = TimeInterval((2 - weekday) * 24 * 3600)
        return startOfDay(for: date.addingTimeInterval(difference))
    }
    
    func firstDayOfMonth(for date: Date) -> Date{
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: date)
        let returnDate = calendar.date(from: components)!
        return returnDate
    
    }
    
    func lastDayOfMonth (for date: Date) -> Date{
        
        var components = DateComponents()
        components.month = 1
        components.second = -1
        let startOfMonth = firstDayOfMonth(for: date)
        let returnDate = Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
        return returnDate
        
        
    }
    
    func numberOfDaysInMonth(date: Date) -> Int {
        
        let calendar = Calendar.current
        let date = date
        let interval = calendar.dateInterval(of: .month, for: date)!
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        
        return days
    }
    
}


// let df = DateFormatter()
// df.setLocalizedDateFormatFromTemplate("LLLLYYYY")
