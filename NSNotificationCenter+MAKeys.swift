//
//  NSNotificationCenter+MAKeys.swift
//  Sarah
//
//  Created by Alex on 04/02/16.
//  Copyright © 2016 appswithlove. All rights reserved.
//

import Foundation

enum NSNotificationKey : String {
    case Result = "result", UserInfo = "userInfo", Error = "error"
}

private class NotificationUserInfoWrapper {
    var data:Any?
    init(_ data:Any?) {
        self.data = data
    }
}

extension NSNotification {
    var result:Any? {
        return (data(.Result) as? NotificationUserInfoWrapper)?.data
    }
    var error:ErrorType? {
        return (data(.Error) as? NotificationUserInfoWrapper)?.data as? ErrorType
    }
    var userData:[String:Any]? {
        return (data(.UserInfo) as? NotificationUserInfoWrapper)?.data as? [String:Any]
    }
    func data(key:NSNotificationKey) -> AnyObject? {
        return userInfo?[key.rawValue]
    }
    private class func generateDictionary(result:Any?=nil, error:ErrorType?=nil, userData:[String:Any]?=nil) -> [String:AnyObject] {
        var dic:[String:AnyObject] = [:]
        if let res = result {
            dic[NSNotificationKey.Result.rawValue] = NotificationUserInfoWrapper(res)
        }
        if let err = error {
            dic[NSNotificationKey.Error.rawValue] = NotificationUserInfoWrapper(err)
        }
        if let user = userData {
            dic[NSNotificationKey.UserInfo.rawValue] = NotificationUserInfoWrapper(user)
        }
        return dic
    }
    convenience init(name:String, object:AnyObject?=nil, result:Any?=nil, error:ErrorType?=nil, userData:[String:Any]?=nil) {
        self.init(name: name, object: object, userInfo: NSNotification.generateDictionary(result, error: error, userData: userData))
    }
}

extension NSNotificationCenter {
    func sendNotification(name:String, object:AnyObject?=nil, result:Any?=nil, error:ErrorType?=nil, userData:[String:Any]?=nil) {
        self.postNotification(NSNotification(name: name, object: object, result: result, error: error, userData: userData))
    }
}