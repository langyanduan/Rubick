//
//  MemoryCache.swift
//  Rubick
//
//  Created by WuFan on 16/9/20.
//
//

import Foundation

public final class MemoryCache<Element>: CacheProtocol {
    private let lruCache: LruCache<String, Element> = LruCache()
    
    // protocol Cache
    public func containsObject(forKey key: String) -> Bool {
        return lruCache.contains(key)
    }
    public func object(forKey key: String) -> Element? {
        return lruCache.value(forKey: key)
    }
    public func setObject(_ anObject: Element, forKey key: String) {
        lruCache.set(value: anObject, forKey: key)
    }
    public func removeObject(forKey key: String) {
        lruCache.remove(forKey: key)
    }
    public func removeAllObjects() {
        lruCache.removeAll()
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMemoryWarning), name: Notification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func didReceiveMemoryWarning() {
        lruCache.removeAll()
    }
}
