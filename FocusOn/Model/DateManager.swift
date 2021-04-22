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
}


// let df = DateFormatter()
// df.setLocalizedDateFormatFromTemplate("LLLLYYYY")
