//
//  MemoryCache.swift
//  Rubick
//
//  Created by WuFan on 16/9/20.
//
//

import Foundation

fileprivate class LinkedMap {
    class Node {
        
    }
    
    var dict: CFMutableDictionary
    var headNode: Node?
    var tailNode: Node?
    
    
    init() {
        var keyCallBacks = kCFTypeDictionaryKeyCallBacks
        var valueCallBacks = kCFTypeDictionaryValueCallBacks
        
        dict = CFDictionaryCreateMutable(nil, 0, &keyCallBacks, &valueCallBacks)
        
    }
    
    
}





class MemoryCache: Cache {
    func containsObject(forKey key: String) -> Bool {
        return false
    }
    
    func object(forKey key: String) -> Any? {
        return nil
    }
    
    func setObject(_ object: Any, forKey key: String) {
        
    }
}
