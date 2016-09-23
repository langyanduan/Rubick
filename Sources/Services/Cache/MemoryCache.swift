//
//  MemoryCache.swift
//  Rubick
//
//  Created by WuFan on 16/9/20.
//
//

import Foundation

final class MemoryCache<Element: AnyObject>: Cache {
    let backed: NSCache<NSString, Element> = NSCache()
    
    // protocol Cache
    func containsObject(forKey key: String) -> Bool {
        return backed.object(forKey: key as NSString) != nil
    }
    func object(forKey key: String) -> Element? {
        return backed.object(forKey: key as NSString)
    }
    func setObject(_ object: Element, forKey key: String, withCost cost: Int = 0) {
        backed.setObject(object, forKey: key as NSString)
    }
    func removeObject(forKey key: String) {
        backed.removeObject(forKey: key as NSString)
    }
    func removeAllObjects() {
        backed.removeAllObjects()
    }
    
    func containsObject(forKey key: String, _ closure: @escaping (MemoryCache<Element>, String, Bool) -> Void) { }
    func object(forKey key: String, _ closure: @escaping (MemoryCache<Element>, String, Element?) -> Void) { }
    func setObject(_ object: Element, forKey key: String, withCost cost: Int = 0, _ closure: @escaping (MemoryCache<Element>, String, Element?) -> Void) { }
    
}
