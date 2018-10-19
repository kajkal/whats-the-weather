//
//  Formatter.swift
//  whats-the-weather
//
//  Created by mackjkl on 10/19/18.
//  Copyright © 2018 kjkl. All rights reserved.
//

import Foundation

class Formatter {
    
    // basic date formatter to decode JSON data
    static let basicDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    private static let dayNameDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    private static let unitMap: [String: String] = [
        "t": " [°C]",
        "w": " [mph]",
        "p": " [mbar]",
    ]
    
    // formatters
    static func getFormattedDouble(d: Double, type: String) -> String {
        return String(format: "%.2f\(unitMap[type] ?? "")", d)
    }
    
    static func getDateToDisplay(date: Date) -> String {
        return displayDateFormatter.string(from: date)
    }
    
    static func getDayName(date: Date) -> String {
        return dayNameDateFormatter.string(from: date)
    }
}
