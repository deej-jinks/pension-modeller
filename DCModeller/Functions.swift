//
//  Functions.swift
//  DCModeller
//
//  Created by Daniel Jinks on 15/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import Foundation

public func createPercentageNumberFormatter() -> (NSNumberFormatter) {
    let myNSNumberFormatter = NSNumberFormatter()
    myNSNumberFormatter.multiplier = 100
    myNSNumberFormatter.maximumFractionDigits = 1
    myNSNumberFormatter.minimumFractionDigits = 1
    myNSNumberFormatter.minimumIntegerDigits = 1
    myNSNumberFormatter.positiveSuffix = "%"
    myNSNumberFormatter.negativeSuffix = "%"
    myNSNumberFormatter.zeroSymbol = "0%"
    return (myNSNumberFormatter)
}

public func createNumberFormatter(maxValue maxValue: Double, prefix: String) -> (NSNumberFormatter) {
    var mySuffix = ""
    var myDivisor = 1.0
    
    let myNSNumberFormatter = NSNumberFormatter()
    
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
    myNSNumberFormatter.multiplier = (1 / myDivisor)
    myNSNumberFormatter.groupingSize = 3
    myNSNumberFormatter.groupingSeparator = ","
    myNSNumberFormatter.usesGroupingSeparator = true
    
    return (myNSNumberFormatter)
}

// MARK: - Date helper functions / extensions

extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date, toDate: self, options: .WrapComponents).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date, toDate: self, options: .WrapComponents).month
    }
//    func weeksFrom(date:NSDate) -> Int{
//        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: date, toDate: self, options: nil).weekOfYear
//    }
//    func daysFrom(date:NSDate) -> Int{
//        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: date, toDate: self, options: nil).day
//    }
//    func hoursFrom(date:NSDate) -> Int{
//        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: date, toDate: self, options: nil).hour
//    }
//    func minutesFrom(date:NSDate) -> Int{
//        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMinute, fromDate: date, toDate: self, options: nil).minute
//    }
//    func secondsFrom(date:NSDate) -> Int{
//        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitSecond, fromDate: date, toDate: self, options: nil).second
//    }
//    func offsetFrom(date:NSDate) -> String {
//        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
//        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
//        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
//        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
//        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
//        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
//        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
//        return ""
//    }
}

//let date1 = NSCalendar.currentCalendar().dateWithEra(1, year: 2014, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
//let date2 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 8, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
//
//let years = date2.yearsFrom(date1)     // 0
//let months = date2.monthsFrom(date1)   // 9
//let weeks = date2.weeksFrom(date1)     // 39
//let days = date2.daysFrom(date1)       // 273
//let hours = date2.hoursFrom(date1)     // 6,553
//let minutes = date2.minutesFrom(date1) // 393,180
//let seconds = date2.secondsFrom(date1) // 23,590,800

public func setNewDateFromExcelNumber(number: Double) -> NSDate? {
    let date = NSDate(timeInterval: (number - 1.1) * 86400, sinceDate: setNewDate(year: 1900, month: 1, day: 1)!)
    return date
}

public func setNewDate (year year:Int,month:Int,day:Int) -> NSDate? {
    let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    
    let myDateComponents = NSDateComponents()
    myDateComponents.timeZone = NSTimeZone(abbreviation: "GMT")
    myDateComponents.year = year
    myDateComponents.month = month
    myDateComponents.day = 1
    
    let daysInMonth = myCalendar?.rangeOfUnit(.Day, inUnit: .Month, forDate: (myCalendar?.dateFromComponents(myDateComponents))!).length
    
    if day > daysInMonth {
        return nil
    } else {
        myDateComponents.day = day
        return myCalendar!.dateFromComponents(myDateComponents)
    }
}

public func getStringForDate (date: NSDate) -> String {
    let myDateFormatter = NSDateFormatter()
    myDateFormatter.dateFormat = "d MMMM yyyy"
    return myDateFormatter.stringFromDate(date)
}

public func getStringForDate_ShortMonth (date: NSDate) -> String {
    let myDateFormatter = NSDateFormatter()
    myDateFormatter.dateFormat = "d MMM yyyy"
    return myDateFormatter.stringFromDate(date)
}


// to allow dates to be compared using == and <, >
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }
