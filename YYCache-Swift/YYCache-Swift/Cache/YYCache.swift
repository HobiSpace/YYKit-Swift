//
//  YYCache.swift
//  YYCache-Swift
//
//  Created by hebi on 2018/7/29.
//  Copyright © 2018年 Hobi. All rights reserved.
//

import UIKit



class YYCache: NSObject {
    public var name: String
    private(set) var totalCount: UInt
    private(set) var totalCost: UInt
    
    
    override init() {
        name = ""
        totalCount = 0
        totalCost = 0
        
        lock = pthread_mutex_t.init()
        lru = YYLinkedMap.init()
        queue = DispatchQueue.init(label: "com.hobi.yycache")
        super.init()
    }
}

// MARK: Access Methods
extension YYCache {
    func containsObject(forKey key: String) -> Bool {
        
    }
    
    func object(forKey key: Any) -> Any? {
        return nil
    }
    
    func setObject(_ object: Any?, forKey key: Any) {
        
    }
    
    func setObject(_ object: Any?, forKey key: Any, withCost cost: UInt) -> Void {
        
    }
    
    func removeObject(forKey key: Any) -> Void {
        
    }
    
    func removeAllObjects() {
        
    }
}

// MARK: Trim
extension YYCache {
    func trim(toCount count:UInt) {
        
    }
    
    func trim(toCost cost:UInt) {
        
    }
    
    func trim(toAge age:TimeInterval) {
        
    }
}
