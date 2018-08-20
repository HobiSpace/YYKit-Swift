//
//  YYDiskCache.swift
//  YYCache-Swift
//
//  Created by hebi on 2018/7/29.
//  Copyright © 2018年 Hobi. All rights reserved.
//

import UIKit

class YYDiskCache: NSObject, YYCacheProtocol {
    var name: String
    
    var totalCount: UInt
    
    var totalCost: UInt
    
    var countLimit: UInt
    
    var costLimit: UInt
    
    var ageLimit: TimeInterval
    
    var autoTrimInterval: TimeInterval
    
    func containsObject(forKey key: AnyHashable) -> Bool {
        <#code#>
    }
    
    func object(forKey key: AnyHashable) -> Any? {
        <#code#>
    }
    
    func setObject(_ object: Any?, forKey key: AnyHashable) {
        <#code#>
    }
    
    func setObject(_ object: Any?, forKey key: AnyHashable, withCost cost: UInt) {
        <#code#>
    }
    
    func removeObject(forKey key: AnyHashable) {
        <#code#>
    }
    
    func removeAllObjects() {
        <#code#>
    }
    
    func trim(toCount count: UInt) {
        <#code#>
    }
    
    func trim(toCost cost: UInt) {
        <#code#>
    }
    
    func trim(toAge age: TimeInterval) {
        <#code#>
    }
    
    
}
