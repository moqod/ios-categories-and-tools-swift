//
//  Array+MATools.swift
//  Moqod
//
//  Created by Alex on 29.12.15.
//  Copyright © 2015 moqod. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
    
    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}