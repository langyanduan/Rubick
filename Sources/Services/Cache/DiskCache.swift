//
//  DiskCache.swift
//  Rubick
//
//  Created by WuFan on 16/9/20.
//
//

import Foundation


public let DiskCacheDirectory = "com.rubick"
public let DiskCachePath = FileHelper.shared.cachesDirectory.ext.appendingPathComponent(DiskCacheDirectory)

final class DiskCache<Element: NSCoding>: Cache {
    
    // protocol Cache
    func containsObject(forKey key: String) -> Bool {
        _ = Digest(algorithm: .md5).update(fromData: key.data(using: .utf8)!).final()
        
        
        return false
    }
    
    func object(forKey key: String) -> Element? {
        return nil
    }
    
    func setObject(_ object: Element, forKey key: String) {
        
    }
    func removeObject(forKey key: String) {
        
    }
    func removeAllObjects() {
        
    }
    
    let storePath: String
    
    init(path: String? = nil) {
        storePath = DiskCachePath.ext.appendingPathComponent(path ?? "")
        FileHelper.shared.createDirectory(atPath: storePath)
    }
}
