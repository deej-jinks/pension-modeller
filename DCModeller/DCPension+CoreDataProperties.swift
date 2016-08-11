//
//  DCPension+CoreDataProperties.swift
//  F1rstPension
//
//  Created by Daniel Jinks on 11/08/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DCPension {

    @NSManaged var annuitySpouseProportion: NSNumber?
    @NSManaged var cashProportion: NSNumber?
    @NSManaged var currentFundValue: NSNumber?
    @NSManaged var incomeInflationaryIncreases: NSNumber?
    @NSManaged var initialDrawdownIncome: NSNumber?
    @NSManaged var investmentReturnInDrawdown: NSNumber?
    @NSManaged var investmentReturnsPreRetirement: NSNumber?
    @NSManaged var name: String?
    @NSManaged var selectedRetirementAge: NSNumber?
    @NSManaged var totalContributionRate: NSNumber?
    @NSManaged var memberContributionRate: NSNumber?
    @NSManaged var employerContributionRate: NSNumber?
    @NSManaged var user: User?

}
