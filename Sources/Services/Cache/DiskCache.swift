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


private protocol _DiskCacheType { }

public class DiskCache<Element: CacheSerializer>: CacheProtocol, AsyncCacheProtocol, _DiskCacheType {
    
    private func filePath(forKey key: String) -> String {
        let md5 = Digest(algorithm: .md5).update(fromData: key.data(using: .utf8)!).final()
        let path = storePath.ext.appendingPathComponent(md5.ext.hexString())
        return path
    }
    
    // protocol Cache
    public func containsObject(forKey key: String) -> Bool {
        return FileHelper.shared.fileExists(atPath: filePath(forKey: key))
    }
    
    public func object(forKey key: String) -> Element? {
        
        do {
            let url = URL(fileURLWithPath: filePath(forKey: key))
            let data = try Data(contentsOf: url)
            
            return nil
            
        } catch {
            return nil
        }
    }
    
    public func setObject(_ object: Element, forKey key: String) {
        
    }
    public func removeObject(forKey key: String) {
        
    }
    public func removeAllObjects() {
        
    }
    
    public var asyncQueue: DispatchQueue = DispatchQueue.main
    
    let storePath: String
    
    init(path: String? = nil) {
        storePath = DiskCachePath.ext.appendingPathComponent(path ?? "")
        FileHelper.shared.createDirectory(atPath: storePath)
    }
}

