//
//  DateExtension.swift
//  Cook And Food
//
//  Created by Trịnh Xuân Minh on 05/04/2021.
//

import Foundation
import UIKit

extension Date {
    func asStringDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func asStringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func asStringDateEnglish() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self.toLocalTime())
    }
    
    func toLocalTime() -> Date {
        return Date(timeInterval: TimeInterval(TimeZone.current.secondsFromGMT(for: self)), since: self)
    }
    
    func resetTime(_ hour: Int = 0, _ minute: Int = 0, _ second: Int = 0) -> Date {
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: second, of: self)!
    }
    
    func nextDate(_ number: Int = 100) -> Date {
        return Calendar.current.date(byAdding: .day, value: number, to: self)!
    }
    
    func settingDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        return Calendar(identifier: .gregorian).date(from: dateComponents)!
    }
    
    func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    func getMonth() -> Int {
        return Calendar.current.component(.month, from: self)
    }
    
    func getYear() -> Int {
        return Calendar.current.component(.year, from: self)
    }
}
