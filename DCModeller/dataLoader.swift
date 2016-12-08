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
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AnnuitySet")
        
        if #available(iOS 9.0, *) {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            do {
                try context.execute(batchDeleteRequest)
            } catch {print("Error: \(error)")}
        } else {
            do {
                let result = try context.fetch(request) as! [NSManagedObject]
                for res in result
                {
                    let managedObjectData = res as NSManagedObject
                    context.delete(managedObjectData)
                }
            } catch {print("Error: \(error)")}
        }

    }

    func parseAndAddData() {
        
        let bundle = Bundle.main
        let path = bundle.path(forResource: "annutiyTable", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        var json : Payload!
        
    //    dispatch_async(dispatch_get_main_queue()) { () -> Void in
    //        delegate.dataParserDidUpdateProgress(0.05, progressAfterNextTask: 0.6, estimatedDurationOfNextTask: 4.0)
    //    }
        
        print("data loading")
        do {
            json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! Payload
        } catch{ print(error)}

        
        //get entities
        let entities = json["annuitiesTable"] as! Payload
        
        let annuitySets = entities["annuities"] as! [Payload]

        //parse and add into DB
        for i in 0..<annuitySets.count {
            let set = annuitySets[i]
            
            let request = NSEntityDescription.insertNewObject(forEntityName: "AnnuitySet", into: context) as! AnnuitySet
            //print("inserting annuity set")
            request.retirementAge = set["retAge"]! as! Double as NSNumber?
            request.gender = set["gender"]! as? String
            request.yearOfBirth = set["yearOfBirth"]! as! Double as NSNumber?
            request.slNonIncAnnuity = set["singleLifeAnnNonInc"]! as! Double as NSNumber?
            request.jlNonIncAnnuity = set["jointLifeAnnNonInc"]! as! Double as NSNumber?
            request.slIncAnnuity = set["singleLifeAnnInc"]! as! Double as NSNumber?
            request.jlIncAnnuity = set["jointLifeAnnInc"]! as! Double as NSNumber?
            request.lifeExpectancyFromRetirement = set["lifeExpectancy"]! as! Double as NSNumber?
            
        }
    }
}
