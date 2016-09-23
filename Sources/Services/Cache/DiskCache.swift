//
//  DiskCache.swift
//  Rubick
//
//  Created by WuFan on 16/9/20.
//
//

import Foundation

public let DiskCacheRootPath = ""

final class DiskCache<Element: NSCoding>: Cache {
    
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
    
    func containsObject(forKey key: String, _ closure: @escaping (DiskCache<Element>, String, Bool) -> Void) { }
    func object(forKey key: String, _ closure: @escaping (DiskCache<Element>, String, Element?) -> Void) { }
    func setObject(_ object: Element, forKey key: String, withCost cost: Int = 0, _ closure: @escaping (DiskCache<Element>, String, Element?) -> Void) { }
    
    
    
    
    let storePath: String
    
    init(path: String? = nil) {
        storePath = FileHelper.shared.cachesDirectory.ext.appendingPathComponent(DiskCacheRootPath).ext.appendingPathComponent(path ?? "")
    }
}
