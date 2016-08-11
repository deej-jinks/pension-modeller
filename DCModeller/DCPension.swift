//
//  DCPension.swift
//  DCModeller
//
//  Created by Daniel Jinks on 15/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import Foundation
import CoreData


class DCPension: NSManagedObject {
    
    var drawdownFundValuesAndIncome: (incomes: [Double], fundValues:[Double]) {
        
        
        let investmentReturn = (1.0 + Double(investmentReturnInDrawdown!))
        let incomeIncreases = Bool(incomeInflationaryIncreases!) ? (1.0 + Double(currentUser!.priceInflation!)) : 1.0
        
        //incomes for year to come - i.e. incomes[1] = income for second year
        var incomes: [Double] = [min(Double(initialDrawdownIncome!), (fundValueAtRetirement - cashAmount) * pow(investmentReturn,0.5))]
        
        //fund values at year start - i.e. fundvalues[1] = fund value at start of second year (so after 1 year)
        var fundValues: [Double] = [fundValueAtRetirement - cashAmount]
        
        
        
        for _ in agesFromRetirementAgeAsStrings {
            
            //calculate new fundvalue using income from previous year
            let newFV = (fundValues.last! * investmentReturn - incomes.last! * pow(investmentReturn,0.5))
            fundValues.append(newFV)
            
            //calculate new income, capping at current fund value
            let newIncome = (min(incomes.last! * incomeIncreases, newFV * pow(investmentReturn,0.5)))
            incomes.append(newIncome)
        }
        
        let inflationDeflator = (1.0 + Double(currentUser!.priceInflation!))
        for i in 0..<agesFromRetirementAgeAsStrings.count {
            incomes[i] *= pow(inflationDeflator, Double(-i))
            fundValues[i] *= pow(inflationDeflator, Double(-i))
        }
        
        return (incomes,fundValues)
    }
    
    var yearsToRetirement: Int {
        return Int(selectedRetirementAge!) - Int(currentUser!.ageNearest)
    }
    
    var preRetirementFundValues: [Double] {
        var fundVals = [Double(currentFundValue!)]
        var salary = Double(user!.salary!) * pow((1 + Double(user!.salaryInflation!)),0.5)
        var fundValue = Double(currentFundValue!)
        for i in (Int(user!.ageNearest) + 1)...75 {
            fundValue = fundValue * (1 + Double(investmentReturnsPreRetirement!)) + salary * Double(totalContributionRate!) * pow((1 + Double(investmentReturnsPreRetirement!)),0.5)
            let deflator = pow((1 + Double(user!.priceInflation!)),Double(Int(user!.ageNearest) - i))
            fundVals.append(fundValue * deflator)
            salary *= (1 + Double(user!.salaryInflation!))
        }
        return fundVals
    }
    
    var fundValueAt75: Double {
        return preRetirementFundValues.last!
    }
    
    var fundValueAtRetirement: Double {
        //print("geeting FV at retirement. retAge : \(selectedRetirementAge!), ageNearest : \(user!.ageNearest)")
        return preRetirementFundValues[Int(selectedRetirementAge!) - Int(user!.ageNearest)]
    }
    
    var fundValueAtRetirementNominal: Double {
        return fundValueAtRetirement * pow(1.0 + Double(currentUser!.priceInflation!),Double(yearsToRetirement))
    }
    
    var agesFromRetirementAgeAsStrings: [String] {
        var ages: [String] = []
        for i in Int(selectedRetirementAge!)...100 {
            ages.append("\(i)")
        }
        return ages
    }
    
    var cashAmount: Double {
        return Double(cashProportion!) * fundValueAtRetirement
    }
    
}

