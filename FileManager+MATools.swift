//
//  FileManager+MATools.swift
//  Moqod
//
//  Created by Alex on 12.01.16.
//  Copyright © 2016 moqod. All rights reserved.
//

import Foundation

public extension NSFileManager {
    struct Directories {
        static var documents:String? = nil
        static var caches:String? = nil
        static var tmp:String? = nil
        static var localDocuments:String? = nil
    }
    public func maDocumentsDirectory() -> String {
        if Directories.documents == nil {
            Directories.documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
        }
        return Directories.documents!
        
    }
    public func maCachesDirectory() -> String {
        if Directories.caches == nil {
            Directories.caches = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        }
        return Directories.caches!
    }
    public func maTemporaryDirectory() -> String {
        if Directories.tmp == nil {
            Directories.tmp = NSTemporaryDirectory()
        }
        return Directories.tmp!
    }
    public func maLocalDocumentsDirectory() -> String {
        if Directories.localDocuments == nil {
            Directories.localDocuments = maDocumentsDirectory().stringByAppendingString("/_local")
            if self.fileExistsAtPath(Directories.localDocuments!) == false {
                _ = try? createDirectoryAtPath(Directories.localDocuments!, withIntermediateDirectories: true, attributes: nil)
                maAddSkipBackupAttribute(Directories.localDocuments!)
            }
        }
        return Directories.localDocuments!
    }
    public func setBackupAttribute(itemPath:String, excludeItem exclude:Bool) throws {
        try NSURL(fileURLWithPath: itemPath).setResourceValue(exclude, forKey: NSURLIsExcludedFromBackupKey)
    }
    public func maAddSkipBackupAttribute(itemPath:String) -> Bool {
        do {
            try setBackupAttribute(itemPath, excludeItem: true)
            return true
        } catch {
            return false
        }
    }
    public func maremoveSkipBackupAttribute(itemPath:String) -> Bool {
        do {
            try setBackupAttribute(itemPath, excludeItem: false)
            return true
        } catch {
            return false
        }
    }
}