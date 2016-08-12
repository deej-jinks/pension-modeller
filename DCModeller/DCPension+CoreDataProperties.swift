//
//  DCPension+CoreDataProperties.swift
//  F1rstPension
//
//  Created by Daniel Jinks on 12/08/2016.
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
    @NSManaged var employerContributionRate: NSNumber?
    @NSManaged var incomeInflationaryIncreases: NSNumber?
    @NSManaged var initialDrawdownIncome: NSNumber?
    @NSManaged var investmentReturnInDrawdown: NSNumber?
    @NSManaged var investmentReturnsPreRetirement: NSNumber?
    @NSManaged var memberContributionRate: NSNumber?
    @NSManaged var name: String?
    @NSManaged var niPayoverProportion: NSNumber?
    @NSManaged var selectedRetirementAge: NSNumber?
    @NSManaged var totalContributionRate: NSNumber? // this can vary from [ = member + employer rate] - as main model allows direct variation of this variable. Former two are used for costing screen only
    @NSManaged var paymentMethod: String? // "net pay", "relief at source", or "salary sacrifice"
    @NSManaged var user: User?

}
