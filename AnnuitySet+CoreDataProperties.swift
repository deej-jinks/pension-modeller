//
//  AnnuitySet+CoreDataProperties.swift
//  DCModeller
//
//  Created by Daniel Jinks on 24/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AnnuitySet {

    @NSManaged var retirementAge: NSNumber?
    @NSManaged var yearOfBirth: NSNumber?
    @NSManaged var gender: String?
    @NSManaged var slNonIncAnnuity: NSNumber?
    @NSManaged var jlNonIncAnnuity: NSNumber?
    @NSManaged var slIncAnnuity: NSNumber?
    @NSManaged var jlIncAnnuity: NSNumber?
    @NSManaged var lifeExpectancyFromRetirement: NSNumber?

}
