//
//  TaxCalculator.swift
//  F1rstPension
//
//  Created by Daniel Jinks on 11/08/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import Foundation

class TaxCalculator {
    // for 2016/2017 tax year ONLY
    
    
    struct IncomeTaxRatesAndLimits {
        static let StandardPersonalAllowance = 11000.0
        static let BasicRateLimit = 32000.0
        static let HigherRateLimit = 150000.0
        
        static let BasicRate = 0.2
        static let HigherRate = 0.4
        static let AdditionalRate = 0.45
        
        static let IncomeLimitForPersonalAllowance = 100000.0
        static let PersonalAllowanceReductionRate = 0.5 //i.e. £x per £1 over income limit
        
    }
    
    struct NIRatesAndLimits {
        static let LEL = 5824.0
        static let PrimaryThreshold = 8060.0
        static let SecondaryThreshold = 8112.0
        static let UEL = 43004.0
        
        static let RateBelowLEL = 0.0
        static let RateFromLELtoPT = 0.0
        static let RateFromPTtoUEL = 0.12
        static let RateFromUEL = 0.02
    }
    
    struct EmployerNIRatesAndLimits {
        static let LEL = 5824.0
        static let PrimaryThreshold = 8060.0
        static let SecondaryThreshold = 8112.0
        static let UEL = 43004.0
        
        static let RateBelowST = 0.0
        static let RateFromSTtoUEL = 0.138
        static let RateFromUEL = 0.138
    }
    
    func employerNIPerYear(_ annualSalary: Double) -> Double {
        var runningTotal = 0.0
        runningTotal += EmployerNIRatesAndLimits.RateBelowST * min(annualSalary,EmployerNIRatesAndLimits.SecondaryThreshold)
        runningTotal += EmployerNIRatesAndLimits.RateFromSTtoUEL * (min(annualSalary,EmployerNIRatesAndLimits.UEL) - min(annualSalary,NIRatesAndLimits.SecondaryThreshold))
        runningTotal += EmployerNIRatesAndLimits.RateFromUEL * (annualSalary - min(annualSalary,EmployerNIRatesAndLimits.UEL))
        return runningTotal
    }
    
    func employerNIPerMonth(_ monthlySalary: Double) -> Double {
        return employerNIPerYear(monthlySalary * 12) / 12
    }
    
    func niPerYear(_ annualSalary: Double) -> Double {
        var runningTotal = 0.0
        runningTotal += NIRatesAndLimits.RateBelowLEL * min(annualSalary,NIRatesAndLimits.LEL)
        runningTotal += NIRatesAndLimits.RateFromLELtoPT * (min(annualSalary,NIRatesAndLimits.PrimaryThreshold) - min(annualSalary,NIRatesAndLimits.LEL))
        runningTotal += NIRatesAndLimits.RateFromPTtoUEL * (min(annualSalary,NIRatesAndLimits.UEL) - min(annualSalary,NIRatesAndLimits.PrimaryThreshold))
        runningTotal += NIRatesAndLimits.RateFromUEL * (annualSalary - min(annualSalary,NIRatesAndLimits.UEL))
        return runningTotal
    }
    
    func niPerMonth(_ monthlySalary: Double) -> Double {
        return niPerYear(monthlySalary * 12) / 12
    }
    
    func incomeTaxPerYear(_ annualSalary: Double) -> Double {

        let excessSalary = (annualSalary - min(annualSalary,IncomeTaxRatesAndLimits.IncomeLimitForPersonalAllowance))
        let adjustedPersonalAllowance = max(0.0, IncomeTaxRatesAndLimits.StandardPersonalAllowance - excessSalary * IncomeTaxRatesAndLimits.PersonalAllowanceReductionRate)
        let taxableEarnings = max(0.0, annualSalary - adjustedPersonalAllowance)
        
        var runningTotal = 0.0
        runningTotal += IncomeTaxRatesAndLimits.BasicRate * min(taxableEarnings, IncomeTaxRatesAndLimits.BasicRateLimit)
        runningTotal += IncomeTaxRatesAndLimits.HigherRate * (min(taxableEarnings, IncomeTaxRatesAndLimits.HigherRateLimit) - min(taxableEarnings, IncomeTaxRatesAndLimits.BasicRateLimit))
        runningTotal += IncomeTaxRatesAndLimits.AdditionalRate * (taxableEarnings - min(taxableEarnings, IncomeTaxRatesAndLimits.HigherRateLimit))
        return runningTotal
    }
    
    func incomeTaxPerMonth(_ monthlySalary: Double) -> Double {
        return incomeTaxPerYear(monthlySalary * 12.0) / 12
    }
    
}
