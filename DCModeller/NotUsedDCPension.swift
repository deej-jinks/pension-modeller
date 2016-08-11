//
//  DCPension.swift
//  DCModeller
//
//  Created by Daniel Jinks on 15/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import Foundation

let mainUser = User()
//let mainDCPension = DCPension()

class NotUsedUser {
    var age: Int
    var gender: Gender
    enum Gender {
        case Male
        case Female
    }
    var salary: Double
    var dcPension = DCPension()
    
    init() {
        //load from store, but for now, load dummy data
        age = 40
        gender = .Male
        salary = 50000
    }
}

class NotUsedDCPension {
    // data items
    var initialFundValue: Double
    var employerContributionRate: Double
    
    // key parameters
    var selectedRetirementAge = 65
    var memberContributionRate = 0.0
    
    // other parameters
    // build-up phase
    var priceInflation = 0.0 // this probably needs to be in a more general class
    var salaryInflation = 0.0 // this probably needs to be in a more general class
    var investmentReturnPreRetirement = 0.0
    
    // cash-out phase
    //both options
    var incomeIncreases = true
    var tfcProportion = 0.0
    
    //annuity
    var spouseProportion = 0.0
    
    //drawdown
    var initialAnnualIncome = 0.0
    var investmentReturnPostRetirement = 0.0
    
    init() {
        //would load data from store
        // but just add some default data here
        initialFundValue = 75000
        employerContributionRate = 0.07
        selectedRetirementAge = 65
        memberContributionRate = 0.0
        priceInflation = 0.025
        salaryInflation = 0.025
        investmentReturnPreRetirement = 0.05
        incomeIncreases = true
        tfcProportion = 0.25
        spouseProportion = 0.5
        initialAnnualIncome = 0.0 // not sure how the default should work for this.....
        investmentReturnPostRetirement = 0.025
    }
    
    func save() {
        // save data to store
    }
    
//    var projectedFundAtRetirement {
//        for i in 1...(
//    }
    
}
