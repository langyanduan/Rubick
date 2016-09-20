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


typealias CacheObjectClosure = (_ cache: MemoryCache, _ key: String, _ object: Any?) -> Void


class MemoryCache: Cache {
    func containsObject(forKey key: String) -> Bool {
        return false
    }
    
    func object(forKey key: String) -> Any? {
        return nil
    }
    
    func object(forKey key: String, _ closure: @escaping CacheObjectClosure) {
    }
    
    
    func setObject(_ object: Any, forKey key: String, withCost cost: Int = 0) {
        
        
    }
    
    func setObject(_ object: Any, forKey key: String, withCost cost: Int = 0, _ closure: @escaping CacheObjectClosure) {
    }
    
    func removeObject(forKey key: String) {
        
    }
    
    func removeAllObjects() {
    }
}
