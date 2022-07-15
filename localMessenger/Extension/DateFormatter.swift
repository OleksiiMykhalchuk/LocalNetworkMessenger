//
//  DateFormatter.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/15/22.
//

import Foundation

extension Date {
    func customFormatt() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy, hh:mm:ss"
        let string = formatter.string(from: self)
        return string
    }
}
