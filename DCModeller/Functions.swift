//
//  Functions.swift
//  DCModeller
//
//  Created by Daniel Jinks on 15/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import Foundation
import Charts
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

public func getFivesFormatter() -> IAxisValueFormatter {
    let formatter = DefaultAxisValueFormatter { (value, axisBase) -> String in
        if Int(value) % 5 == 0 {
            return "\(Int(value))"
        } else {
            return ""
        }
    }
    return formatter
}

public func createPercentageNumberFormatter() -> (NumberFormatter) {
    let myNSNumberFormatter = NumberFormatter()
    myNSNumberFormatter.multiplier = 100
    myNSNumberFormatter.maximumFractionDigits = 1
    myNSNumberFormatter.minimumFractionDigits = 1
    myNSNumberFormatter.minimumIntegerDigits = 1
    myNSNumberFormatter.positiveSuffix = "%"
    myNSNumberFormatter.negativeSuffix = "%"
    myNSNumberFormatter.zeroSymbol = "0%"
    return (myNSNumberFormatter)
}

public func createNumberFormatter(maxValue: Double, prefix: String) -> (NumberFormatter) {
    var mySuffix = ""
    var myDivisor = 1.0
    
    let myNSNumberFormatter = NumberFormatter()
    
    switch maxValue {
    case 0..<100:
        mySuffix = ""
        myDivisor = 1
        myNSNumberFormatter.maximumFractionDigits = 1
        myNSNumberFormatter.minimumFractionDigits = 1
    case 100..<10000:
        mySuffix = ""
        myDivisor = 1
        myNSNumberFormatter.maximumFractionDigits = 0
        myNSNumberFormatter.minimumFractionDigits = 0
    case 10000..<1000000:
        mySuffix = "k"
        myDivisor = 1000
        myNSNumberFormatter.maximumFractionDigits = 0
        myNSNumberFormatter.minimumFractionDigits = 0
    case 1000000..<1000000000:
        mySuffix = "m"
        myDivisor = 1000000
        myNSNumberFormatter.maximumFractionDigits = 1
        myNSNumberFormatter.minimumFractionDigits = 1
    case 100000000..<5000000000:
        mySuffix = "m"
        myDivisor = 1000000
        myNSNumberFormatter.maximumFractionDigits = 0
        myNSNumberFormatter.minimumFractionDigits = 0
    case 5000000000..<1000000000000000:
        mySuffix = "b"
        myDivisor = 1000000000
    default:
        mySuffix = ""
        myDivisor = 1
    }
    
    myNSNumberFormatter.minimumIntegerDigits = 1
    myNSNumberFormatter.positiveSuffix = mySuffix
    myNSNumberFormatter.negativeSuffix = mySuffix
    myNSNumberFormatter.positivePrefix = prefix
    myNSNumberFormatter.negativePrefix = prefix
    myNSNumberFormatter.zeroSymbol = prefix + "0" + mySuffix
    myNSNumberFormatter.multiplier = NSNumber(value:(1 / myDivisor))
    myNSNumberFormatter.groupingSize = 3
    myNSNumberFormatter.groupingSeparator = ","
    myNSNumberFormatter.usesGroupingSeparator = true
    
    return (myNSNumberFormatter)
}

// MARK: - Date helper functions / extensions

extension Date {
    func yearsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(NSCalendar.Unit.year, from: date, to: self, options: .wrapComponents).year!
    }
    func monthsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(NSCalendar.Unit.month, from: date, to: self, options: .wrapComponents).month!
    }
}

public func setNewDateFromExcelNumber(_ number: Double) -> Date? {
    let date = Date(timeInterval: (number - 1.1) * 86400, since: setNewDate(year: 1900, month: 1, day: 1)!)
    return date
}

public func setNewDate (year:Int,month:Int,day:Int) -> Date? {
    let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
    
    var myDateComponents = DateComponents()
    (myDateComponents as NSDateComponents).timeZone = TimeZone(abbreviation: "GMT")
    myDateComponents.year = year
    myDateComponents.month = month
    myDateComponents.day = 1
    
    let daysInMonth = (myCalendar as NSCalendar?)?.range(of: .day, in: .month, for: (myCalendar.date(from: myDateComponents))!).length
    
    if day > daysInMonth {
        return nil
    } else {
        myDateComponents.day = day
        return myCalendar.date(from: myDateComponents)
    }
}

public func getStringForDate (_ date: Date) -> String {
    let myDateFormatter = DateFormatter()
    myDateFormatter.dateFormat = "d MMMM yyyy"
    return myDateFormatter.string(from: date)
}

public func getStringForDate_ShortMonth (_ date: Date) -> String {
    let myDateFormatter = DateFormatter()
    myDateFormatter.dateFormat = "d MMM yyyy"
    return myDateFormatter.string(from: date)
}

/*
// to allow dates to be compared using == and <, >
public func ==(lhs: Date, rhs: Date) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .orderedSame
}

public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
}
*/
//extension Date: Comparable { }
