//
//  UITextView + Strikethrough.swift
//  FocusOn
//
//  Created by James Tapping on 25/03/2021.
//

import Foundation
import UIKit

extension NSAttributedString {

    func strikedAttributedString(fraction: Double = 1, type: NSUnderlineStyle) -> NSAttributedString {
        
        // let type:NSUnderlineStyle = .thick
        
        let range = NSRange(0..<Int(fraction * Double(length)))
        return strike(with: type, range: range)
    }
    

    var unstrikedAttributedString: NSAttributedString {
        
        return strike(with: [])
    }

    private func strike(with style: NSUnderlineStyle, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        let attributeName = NSAttributedString.Key.strikethroughStyle
        let fullRange = NSRange(0..<length)
        mutableAttributedString.removeAttribute(attributeName, range: fullRange)
        mutableAttributedString.addAttribute(attributeName, value: style.rawValue, range: range ?? fullRange)

        mutableAttributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.midnightBlue as Any, range: NSMakeRange(0, mutableAttributedString.length))
        
        return mutableAttributedString
    }

}
    extension UITextView {

        func strike(fraction: Double = 1, type: NSUnderlineStyle) {
            attributedText = attributedText?.strikedAttributedString(fraction: fraction, type: type)
        }

        func unstrike() {
            attributedText = attributedText?.unstrikedAttributedString
        }

    }

