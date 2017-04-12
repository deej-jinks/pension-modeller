//
//  incomeCalculator.swift
//  DCModeller
//
//  Created by Daniel Jinks on 24/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import Foundation
import CoreData

class DataFinder {
    
    func getLifeExpectancyFromRetirement() -> Double? {
        if let set = getAnnuitySet() {
            return Double(set.lifeExpectancyFromRetirement!) + Double(currentDCPension!.selectedRetirementAge!)
        } else {
            return nil
        }
    }
    
    func getAnnuityIncome() -> [Double]? {
    
        var annuityFactor = 999.0
        
        //find annuity factor
        let annuitySet = getAnnuitySet()
        if Bool(currentDCPension!.incomeInflationaryIncreases!) {
            annuityFactor = Double(annuitySet!.slIncAnnuity!) + (Double(annuitySet!.jlIncAnnuity!) - Double(annuitySet!.slIncAnnuity!)) * Double(currentDCPension!.annuitySpouseProportion!)
        } else {
            annuityFactor = Double(annuitySet!.slNonIncAnnuity!) + (Double(annuitySet!.jlNonIncAnnuity!) - Double(annuitySet!.slNonIncAnnuity!)) * Double(currentDCPension!.annuitySpouseProportion!)
        }
        
        
        let initialIncome = Double(currentDCPension!.fundValueAtRetirement - currentDCPension!.cashAmount) / annuityFactor
        
        var income = [initialIncome]
        for _ in (Int(currentDCPension!.selectedRetirementAge!) + 1)...100 {
            if Bool(currentDCPension!.incomeInflationaryIncreases!) {
                income.append(income.last!)
            } else {
                income.append(income.last! / (1.0 + Double(currentUser!.priceInflation!)))
            }
        }
        return income

    }

    func getAnnuitySet() -> AnnuitySet? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AnnuitySet")
        request.predicate = NSPredicate(format: "retirementAge == %f && yearOfBirth == %d && gender = %@", Double(currentDCPension!.selectedRetirementAge!), currentUser!.yearOfBirth, Bool(currentUser!.isMale!) ? "M" : "F")
        do {
            let results = try AppDelegate.getContext().fetch(request) as! [AnnuitySet]
            return results.first
        } catch { return nil }
    }


}

