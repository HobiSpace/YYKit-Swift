//
//  YYMemoryCache.swift
//  YYCache-Swift
//
//  Created by hebi on 2018/7/29.
//  Copyright © 2018年 Hobi. All rights reserved.
//

import UIKit

fileprivate class YYLinkedMapNode: NSObject {
    var key: AnyHashable
    var value: Any
    var cost: UInt
    var time: TimeInterval
    
    init(_ key: AnyHashable, _ value: Any, _ cost: UInt, _ time: TimeInterval) {
        self.key = key
        self.value = value
        self.cost = cost
        self.time = time
        super.init()
    }
}

class YYLinkedMap: NSObject {
    fileprivate var dic: Dictionary<AnyHashable, Any>
    private var totalCost: UInt
    private var totalCount: UInt
    private var nodeArray: Array<YYLinkedMapNode>
    private var releaseOnMainThread: Bool
    private var releaseAsynchronously: Bool
    
    override init() {
        dic = Dictionary<AnyHashable, Any>()
        totalCost = 0
        totalCount = 0
        nodeArray = Array<YYLinkedMapNode>()
        releaseOnMainThread = true
        releaseAsynchronously = false
        super.init()
    }
    
    fileprivate func insertNodeAtHead(_ node:YYLinkedMapNode) {
        dic.updateValue(node, forKey: node.key)
        totalCost = totalCost + node.cost
        totalCount = totalCount + 1
        nodeArray.insert(node, at: 0)
    }
    
    fileprivate func bringNodeToHead(_ node:YYLinkedMapNode) {
        
        
        let index = nodeArray.index(of: node)
        guard index != 0 else {
            return
        }
        nodeArray.remove(at: index!)
        nodeArray.insert(node, at: 0)
    }
    
    fileprivate func removeNode(_ node:YYLinkedMapNode) {
        dic.removeValue(forKey: node.key)
        let index = nodeArray.index(of: node)
        nodeArray.remove(at: index!)
        totalCost = totalCost - node.cost
        totalCount = totalCount - 1
    }
    
    fileprivate func removeTailNode() -> YYLinkedMapNode? {
        guard let lastNode = nodeArray.last else {
            return nil
        }
        removeNode(lastNode)
        return lastNode
    }
    
    func removeAll() {
        totalCost = 0
        totalCount = 0
        dic.removeAll()
        nodeArray.removeAll()
    }
    
}

class YYMemoryCache: NSObject {
    var name: String
    private(set) var totalCount: UInt
    private(set) var totalCost: UInt
    
    private var lock: pthread_mutex_t
    private var lru: YYLinkedMap
    private var queue: DispatchQueue
    
    // Limit
    var countLimit: UInt
    var costLimit: UInt
    var ageLimit: TimeInterval
    var autoTrimInterval: TimeInterval
    var shouldRemoveAllObjectsOnMemoryWarning: Bool
    var shouldRemoveAllObjectsWhenEnteringBackground: Bool
    
    var didReceiveMemoryWarningBlock: ((YYMemoryCache)->())?
    var didEnterBackgroundBlock: ((YYMemoryCache)->())?
    
    var releaseOnMainThread: Bool
    var releaseAsynchronously: Bool
    
    override init() {
        name = String.init()
        totalCount = 0
        totalCost = 0
        countLimit = 0
        costLimit = 0
        ageLimit = 0
        autoTrimInterval = 0
        shouldRemoveAllObjectsOnMemoryWarning = true
        shouldRemoveAllObjectsWhenEnteringBackground = true
        didReceiveMemoryWarningBlock = nil
        didEnterBackgroundBlock = nil
        releaseOnMainThread = true
        releaseAsynchronously = true
        
        super.init()
        
    }
}


// MARK: - Access Methods
extension YYMemoryCache {
    func containsObject(forKey key: AnyHashable) -> Bool {
        pthread_mutex_lock(&lock)
        let contains = lru.dic[key] != nil
        pthread_mutex_unlock(&lock)
        return contains
    }
    
    func object(forKey key: AnyHashable) -> Any? {
        pthread_mutex_lock(&lock)
        var node: YYLinkedMapNode = lru.dic[key]
        if node
        pthread_mutex_unlock(&lock)
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
extension YYMemoryCache {
    func trim(toCount count:UInt) {
        
    }
    
    func trim(toCost cost:UInt) {
        
    }
    
    func trim(toAge age:TimeInterval) {
        
    }
}
