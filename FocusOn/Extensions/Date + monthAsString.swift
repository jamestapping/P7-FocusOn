//
//  Date + monthAsString.swift
//  FocusOn
//
//  Created by James Tapping on 07/04/2021.
//

import Foundation

extension Date {
    func monthAsString() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("LLLLYYYY")
            return df.string(from: self)
    }
}
