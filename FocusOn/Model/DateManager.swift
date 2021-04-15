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
        // dateFormatter.dateStyle = .long
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = date.dateFormatWithSuffix()
        // dateFormatter.setLocalizedDateFormatFromTemplate("EEEEd")
        
        return dateFormatter.string(from: date)
    }
}


// let df = DateFormatter()
// df.setLocalizedDateFormatFromTemplate("LLLLYYYY")
