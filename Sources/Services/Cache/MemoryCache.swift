//
//  MemoryCache.swift
//  Rubick
//
//  Created by WuFan on 16/9/20.
//
//

import Foundation

final class MemoryCache<Element>: Cache {
    
    // protocol Cache
    func containsObject(forKey key: String) -> Bool {
        return false
    }
    
    func object(forKey key: String) -> Element? {
        return nil
    }
    
    func setObject(_ object: Element, forKey key: String, withCost cost: Int = 0) {
        
    }
    func removeObject(forKey key: String) {
        
    }
    func removeAllObjects() {
        
    }
    
    func containsObject(forKey key: String, _ closure: @escaping (MemoryCache<Element>, String, Bool) -> Void) { }
    func object(forKey key: String, _ closure: @escaping (MemoryCache<Element>, String, Element?) -> Void) { }
    func setObject(_ object: Element, forKey key: String, withCost cost: Int = 0, _ closure: @escaping (MemoryCache<Element>, String, Element?) -> Void) { }
    
}
