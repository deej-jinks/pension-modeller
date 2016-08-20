//
//  User.swift
//  DCModeller
//
//  Created by Daniel Jinks on 18/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {

    var monthlySalary: Double {
        return Double(salary!) / 12.0
    }
    
    var yearOfBirth: Int {
        return NSCalendar.currentCalendar().component(.Year, fromDate: dateOfBirth!)
    }
    
    var ageComplete: Int {
        let x = NSDate(timeIntervalSinceNow: 0.0).yearsFrom(dateOfBirth!)
        return x
    }
    
    var ageNearest: Int {
        let x = NSDate(timeIntervalSinceNow: 0.0).yearsFrom(dateOfBirth!)
        let y = NSDate(timeIntervalSinceNow: 0.0).monthsFrom(dateOfBirth!) % 12
        if y < 6 {
            return x
        } else {
            return x + 1
        }
    }
    
    var agesTo75AsStrings: [String] {
        var ages: [String] = []
        for i in ageNearest...75 {
            ages.append("\(i)")
        }
        return ages
    }

}
