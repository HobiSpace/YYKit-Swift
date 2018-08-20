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
    fileprivate var dic: Dictionary<AnyHashable, YYLinkedMapNode>
    fileprivate var totalCost: UInt
    fileprivate var totalCount: UInt
    private var nodeArray: Array<YYLinkedMapNode>
    private var releaseOnMainThread: Bool
    private var releaseAsynchronously: Bool
    
    override init() {
        dic = Dictionary<AnyHashable, YYLinkedMapNode>()
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

class YYMemoryCache: NSObject, YYCacheProtocol {
    var name: String
    
    var totalCount: UInt
    
    var totalCost: UInt
    
    var countLimit: UInt
    
    var costLimit: UInt
    
    var ageLimit: TimeInterval
    
    var autoTrimInterval: TimeInterval
    
    
    private var lock: pthread_mutex_t
    private var lru: YYLinkedMap
    private var queue: DispatchQueue
    

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
        countLimit = UInt.max
        costLimit = UInt.max
        ageLimit = Double.greatestFiniteMagnitude
        autoTrimInterval = 5.0
        shouldRemoveAllObjectsOnMemoryWarning = true
        shouldRemoveAllObjectsWhenEnteringBackground = true
        didReceiveMemoryWarningBlock = nil
        didEnterBackgroundBlock = nil
        releaseOnMainThread = true
        releaseAsynchronously = true


        lock = pthread_mutex_t.init()
        lru = YYLinkedMap.init()
        queue = DispatchQueue.init(label: "com.hobi.yycache")
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
        if let node: YYLinkedMapNode = lru.dic[key] {
            node.time = CACurrentMediaTime()
            lru.bringNodeToHead(node)
            pthread_mutex_unlock(&lock)
            return node.value
        } else {
            pthread_mutex_unlock(&lock)
            return nil
        }
    }
    
    func setObject(_ object: Any?, forKey key: AnyHashable) {
        setObject(object, forKey: key, withCost: 0)
    }
    
    func setObject(_ object: Any?, forKey key: AnyHashable, withCost cost: UInt) {
        if let obj: Any = object {
            pthread_mutex_lock(&lock)
            if let node: YYLinkedMapNode = lru.dic[key] {
                lru.totalCost = lru.totalCost - node.cost
                lru.totalCost = lru.totalCost + cost
                node.cost = cost
                node.time = CACurrentMediaTime()
                node.value = obj
                lru .bringNodeToHead(node)
            } else {
                let newNode: YYLinkedMapNode = YYLinkedMapNode.init(key, obj, cost, CACurrentMediaTime())
                lru.insertNodeAtHead(newNode)
            }
            if lru.totalCost > costLimit {
                queue.async {
                    self.trim(toCost: self.costLimit)
                }
            }
            if lru.totalCount > costLimit {
                lru.removeTailNode()
            }
            pthread_mutex_unlock(&lock)
        } else {
            removeObject(forKey: key)
            return
        }
    }
    
    func removeObject(forKey key: AnyHashable) {
        pthread_mutex_lock(&lock)
        if let node: YYLinkedMapNode = lru.dic[key] {
            lru .removeNode(node)
        }
        pthread_mutex_unlock(&lock)
    }
    
    func removeAllObjects() {
        pthread_mutex_lock(&lock)
        lru.removeAll()
        pthread_mutex_unlock(&lock)
    }
}

// MARK: Trim
extension YYMemoryCache {
    
    func trim(toCount count: UInt) {
        if count == 0 {
            removeAllObjects()
        } else if lru.totalCount <= count {
            return
        } else {
            while lru.totalCount > count {
                pthread_mutex_lock(&lock)
                lru.removeTailNode()
                pthread_mutex_unlock(&lock)
            }
        }
    }
    
    func trim(toCost cost: UInt) {
        if cost == 0 {
            removeAllObjects()
        } else if lru.totalCost <= cost {
            return
        } else {
            while lru.totalCost > cost {
                pthread_mutex_lock(&lock)
                lru.removeTailNode()
                pthread_mutex_unlock(&lock)
            }
        }
    }
    
    func trim(toAge age: TimeInterval) {
        
    }
}
