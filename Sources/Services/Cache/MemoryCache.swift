//
//  MemoryCache.swift
//  Rubick
//
//  Created by WuFan on 16/9/20.
//
//

import Foundation

public final class MemoryCache<Element>: Cache {
    private let lruCache: LruCache<String, Element>
    
    // protocol Cache
    public func containsObject(forKey key: String) -> Bool {
        return lruCache.contains(key)
    }
    public func object(forKey key: String) -> Element? {
        return lruCache.value(forKey: key)
    }
    public func setObject(_ anObject: Element, forKey key: String) {
        lruCache.set(value: anObject, forKey: key, withCost: 0)
    }
    public func removeObject(forKey key: String) {
        lruCache.remove(forKey: key)
    }
    public func removeAllObjects() {
    }
    
    public func containsObject(forKey key: String, _ closure: @escaping (MemoryCache<Element>, String, Bool) -> Void) { }
    public func object(forKey key: String, _ closure: @escaping (MemoryCache<Element>, String, Element?) -> Void) { }
    public func setObject(_ object: Element, forKey key: String, _ closure: @escaping (MemoryCache<Element>, String, Element?) -> Void) { }
    
    // 
    func trim(toCount count: Int) {
        if count == 0 {
            removeAllObjects()
            return
        }
    }
    
    func trim(toCost cost: Int) {
        if cost == 0 {
            removeAllObjects()
            return
        }
        
        
        
    }
    
    func trim(toAge age: TimeInterval) {
        if age < TimeInterval.leastNonzeroMagnitude {
            removeAllObjects()
            return
        }
        
    }
    
    
    init(countLimit: Int = 0, costLimit: Int = 0) {
        lruCache = LruCache(countLimit: countLimit, costLimit: costLimit)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMemoryWarning), name: Notification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func didReceiveMemoryWarning() {
        
    }
}
