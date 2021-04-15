//
//  Date + suffix.swift
//  FocusOn
//
//  Created by James Tapping on 12/04/2021.
//

import Foundation
import UIKit

extension Date {

    func dateFormatWithSuffix() -> String {
        return "EEEE d'\(self.daySuffix())"
    }

    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
}
