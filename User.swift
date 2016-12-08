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
        return (Calendar.current as NSCalendar).component(.year, from: dateOfBirth! as Date)
    }
    
    var ageComplete: Int {
        let x = Date(timeIntervalSinceNow: 0.0).yearsFrom(dateOfBirth!)
        return x
    }
    
    var ageNearest: Int {
        let x = Date(timeIntervalSinceNow: 0.0).yearsFrom(dateOfBirth!)
        let y = Date(timeIntervalSinceNow: 0.0).monthsFrom(dateOfBirth!) % 12
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
