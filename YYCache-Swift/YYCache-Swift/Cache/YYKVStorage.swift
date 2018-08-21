//
//  YYKVStorage.swift
//  YYCache-Swift
//
//  Created by Hobi on 2018/8/17.
//  Copyright © 2018年 Hobi. All rights reserved.
//

import UIKit

class YYKVStorageItem: NSObject {
    var key: String
    var value: Data
    var fileName: String?
    var size: Int
    var modTime: Int
    var accessTime: Int
    var extendedData: Data?
    
    init(forKey key: String, _ value: Data, _ fileName: String?, _ size: Int, _ modTime: Int, _ accessTime: Int, _ extendedData: Data?) {
        self.key = key
        self.value = value
        self.fileName = fileName
        self.size = size
        self.modTime = modTime
        self.accessTime = accessTime
        self.extendedData = extendedData
        super.init()
    }
}

enum YYKVStorageType {
    case File
    case SQLite
    case Mixed
}

class YYKVStorage: NSObject {
    private(set) var path: String
    private(set) var type: YYKVStorageType
    var errorLogsEnabled: Bool
    
    init(withPath path: String, _ type: YYKVStorageType) {
        self.path = path
        self.type = type
        self.errorLogsEnabled = false
        super.init()
        
    }
}

// MARK: - Save Items
extension YYKVStorage {
    func saveItem(_ item: YYKVStorageItem) -> Bool {
        return saveItem(forKey: item.key, value: item.value, fileName: item.fileName, extendedData: item.extendedData)
    }
    
    func saveItem(forKey key: String, value: Data) -> Bool {
        return saveItem(forKey: key, value: value, fileName: nil, extendedData: nil)
    }
    
    func saveItem(forKey key: String, value: Data, fileName: String?, extendedData: Data?) -> Bool {
        guard key.count != 0 || value.count != 0 else {
            return false
        }
        
        if type == .File && fileName?.count == 0 {
            return false
        }
        
    }
}
