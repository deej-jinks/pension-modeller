//
//  dataLoader.swift
//  DCModeller
//
//  Created by Daniel Jinks on 24/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import Foundation
import CoreData

typealias Payload = [String:AnyObject]

class DataLoader {

    var context: NSManagedObjectContext {
//        let pc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
//        pc.parentContext = AppDelegate.getContext()
//        return pc
        return AppDelegate.getContext()
    }

    func clearAnnuityData() {
        let request = NSFetchRequest(entityName: "AnnuitySet")
        
        if #available(iOS 9.0, *) {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            do {
                try context.executeRequest(batchDeleteRequest)
            } catch {print("Error: \(error)")}
        } else {
            do {
                let result = try context.executeFetchRequest(request) as! [NSManagedObject]
                for res in result
                {
                    let managedObjectData = res as NSManagedObject
                    context.deleteObject(managedObjectData)
                }
            } catch {print("Error: \(error)")}
        }

    }

    func parseAndAddData() {
        
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("annutiyTable", ofType: "json")
        let data = NSData(contentsOfFile: path!)
        var json : Payload!
        
    //    dispatch_async(dispatch_get_main_queue()) { () -> Void in
    //        delegate.dataParserDidUpdateProgress(0.05, progressAfterNextTask: 0.6, estimatedDurationOfNextTask: 4.0)
    //    }
        
        print("data loading")
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! Payload
        } catch{ print(error)}

        
        //get entities
        let entities = json["annuitiesTable"] as! Payload
        
        let annuitySets = entities["annuities"] as! [Payload]

        //parse and add into DB
        for i in 0..<annuitySets.count {
            let set = annuitySets[i]
            
            let request = NSEntityDescription.insertNewObjectForEntityForName("AnnuitySet", inManagedObjectContext: context) as! AnnuitySet
            //print("inserting annuity set")
            request.retirementAge = set["retAge"]! as! Double
            request.gender = set["gender"]! as? String
            request.yearOfBirth = set["yearOfBirth"]! as! Double
            request.slNonIncAnnuity = set["singleLifeAnnNonInc"]! as! Double
            request.jlNonIncAnnuity = set["jointLifeAnnNonInc"]! as! Double
            request.slIncAnnuity = set["singleLifeAnnInc"]! as! Double
            request.jlIncAnnuity = set["jointLifeAnnInc"]! as! Double
            request.lifeExpectancyFromRetirement = set["lifeExpectancy"]! as! Double
            
        }
    }
}