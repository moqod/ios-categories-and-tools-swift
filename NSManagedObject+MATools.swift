//
//  NSManagedObject+MATools.swift
//  Moqod
//
//  Created by Alex on 12.01.16.
//  Copyright © 2016 moqod. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    @objc public func updateData(dictionary:[String:AnyObject], context:NSManagedObjectContext?=nil) {}
    @objc public class var maEntityName:String {
        return "NSManagedObject"
    }
    public class var maFetchRequest:NSFetchRequest {
        return NSFetchRequest(entityName: maEntityName)
    }
    public class func maCountInstances(predicate:NSPredicate?=nil, managedObjectContext context:NSManagedObjectContext) -> Int {
        let request = maFetchRequest
        request.predicate = predicate
        var error:NSError?
        let count = context.countForFetchRequest(request, error: &error)
        if count == NSNotFound {
            NSLog("ERROR getting count \(predicate): \(error)")
            return 0
        }
        return count
    }
    public class func maAllInstances(predicate:NSPredicate?=nil, sortDescriptors:[NSSortDescriptor]?=nil, limit:Int?=0, context:NSManagedObjectContext) -> [AnyObject]? {
        let request = maFetchRequest
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        if limit > 0 {
            request.fetchLimit = limit!
        }
        do {
            let results = try context.executeFetchRequest(request)
            return results
        } catch let error as NSError {
            NSLog("ERROR loading \(predicate): \(error)")
            return nil
        }
    }
    public class func maExistInstance(predicate:NSPredicate?=nil, context:NSManagedObjectContext) -> Bool {
        let request = maFetchRequest
        request.predicate = predicate
        request.fetchLimit = 1
        request.fetchBatchSize = 1
        request.includesPropertyValues = false
        do {
            let results = try context.executeFetchRequest(request)
            return (results.count > 0)
        } catch let error as NSError {
            NSLog("ERROR loading \(predicate): \(error)")
            return false
        }
    }
    public class func maSingleInstance(predicate:NSPredicate?=nil, context:NSManagedObjectContext) -> Any? {
        let request = maFetchRequest
        request.predicate = predicate
        request.fetchLimit = 1
        request.fetchBatchSize = 1
        do {
            let results = try context.executeFetchRequest(request)
            return results.first
        } catch let error as NSError {
            NSLog("ERROR loading \(predicate): \(error)")
            return nil
        }
    }
    public class func maNewInstance(inContext context:NSManagedObjectContext) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(maEntityName, inManagedObjectContext: context)
    }
    public class func maAutoCreatedInstance(predicate:NSPredicate?=nil, context:NSManagedObjectContext) -> NSManagedObject {
        var instance = maSingleInstance(predicate, context: context)
        if instance == nil {
            instance = maNewInstance(inContext: context)
        }
        return instance as! NSManagedObject
    }
    public class func maDeleteEntities(predicate:NSPredicate?=nil, context:NSManagedObjectContext) -> Int {
        let request = maFetchRequest
        request.includesPropertyValues = false
        request.predicate = predicate
        do {
            let results = try context.executeFetchRequest(request)
            let count = results.count
            if count > 0 {
                for object in results {
                    context.deleteObject(object as! NSManagedObject)
                }
            }
            return count
        } catch let error as NSError {
            NSLog("ERROR loading \(predicate): \(error)")
            return 0
        }
    }
}
