//
//  YYCache.swift
//  YYCache-Swift
//
//  Created by hebi on 2018/7/29.
//  Copyright © 2018年 Hobi. All rights reserved.
//

import UIKit

protocol YYCacheProtocol {
    var name: String {get set}
    var totalCount: UInt {get}
    var totalCost: UInt {get}
    
    var countLimit: UInt {get set}
    var costLimit: UInt {get set}
    var ageLimit: TimeInterval {get set}
    var autoTrimInterval: TimeInterval {get set}
    
    // Access Methods
    func containsObject(forKey key: AnyHashable) -> Bool
    func object(forKey key: AnyHashable) -> Any?
    func setObject(_ object: Any?, forKey key: AnyHashable)
    func setObject(_ object: Any?, forKey key: AnyHashable, withCost cost: UInt)
    func removeObject(forKey key: AnyHashable)
    func removeAllObjects()
    
    // Trim
    func trim(toCount count: UInt)
    func trim(toCost cost: UInt)
    func trim(toAge age: TimeInterval)
}

class YYCache: NSObject, YYCacheProtocol {
    var name: String
    
    var totalCount: UInt
    
    var totalCost: UInt
    
    var countLimit: UInt
    
    var costLimit: UInt
    
    var ageLimit: TimeInterval
    
    var autoTrimInterval: TimeInterval
    
    
    override init() {
        name = String.init()
        totalCount = 0
        totalCost = 0
        countLimit = UInt.max
        costLimit = UInt.max
        ageLimit = Double.greatestFiniteMagnitude
        autoTrimInterval = 5.0
        super.init()
    }
}

// MARK: Access Methods
extension YYCache {
    func containsObject(forKey key: AnyHashable) -> Bool {
        
    }
    
    func object(forKey key: AnyHashable) -> Any? {
        
    }
    
    func setObject(_ object: Any?, forKey key: AnyHashable) {
        
    }
    
    func setObject(_ object: Any?, forKey key: AnyHashable, withCost cost: UInt) {
        
    }
    
    func removeObject(forKey key: AnyHashable) {
        
    }
    
    func removeAllObjects() {
        
    }
}

// MARK: Trim
extension YYCache {
    func trim(toCount count: UInt) {
        
    }
    
    func trim(toCost cost: UInt) {
        
    }
    
    func trim(toAge age: TimeInterval) {
        
    }
}
