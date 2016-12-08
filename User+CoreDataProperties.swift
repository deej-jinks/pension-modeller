//
//  User+CoreDataProperties.swift
//  DCModeller
//
//  Created by Daniel Jinks on 29/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var dateOfBirth: Date?
    @NSManaged var isMale: NSNumber?
    @NSManaged var name: String?
    @NSManaged var priceInflation: NSNumber?
    @NSManaged var salary: NSNumber?
    @NSManaged var salaryInflation: NSNumber?
    @NSManaged var acceptedTsCs: NSNumber?
    @NSManaged var dcPension: DCPension?

}
