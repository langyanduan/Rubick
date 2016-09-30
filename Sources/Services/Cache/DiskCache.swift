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

public class DiskCache<Element>: CacheProtocol, AsyncCacheProtocol {
    
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
            let object = try serializer.object(forData: data)
            return object
        } catch {
            return nil
        }
    }
    
    public func setObject(_ object: Element, forKey key: String) {
        do {
            let data = try serializer.data(forObject: object)
            let url = URL(fileURLWithPath: filePath(forKey: key))
            try data.write(to: url, options: [.atomicWrite])
        } catch { }
    }
    public func removeObject(forKey key: String) {
        let path = filePath(forKey: key)
        FileHelper.shared.removeFile(atPath: path)
    }
    public func removeAllObjects() {
        
    }
    
    public let asyncQueue: DispatchQueue
    
    let serializer: CacheSerializer<Element>
    let storePath: String
    
    init(path: String? = nil, serializer: CacheSerializer<Element>, asyncQueue: DispatchQueue = .global()) {
        self.storePath = DiskCachePath.ext.appendingPathComponent(path ?? "")
        self.serializer = serializer
        self.asyncQueue = asyncQueue
        
        FileHelper.shared.createDirectory(atPath: storePath)
    }
}

