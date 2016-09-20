//
//  DiskCache.swift
//  Rubick
//
//  Created by WuFan on 16/9/20.
//
//

import Foundation

public let DiskCacheRootPath = ""


class DiskCache: Cache {
//    func containsObject(forKey key: String) -> Bool {
//        return false
//    }
//    
//    func object(forKey key: String) -> Any? {
//        return nil
//    }
//    
//    func setObject(_ object: Any, forKey key: String) {
//        
//    }
    
    let storePath: String
    
    init(path: String? = nil) {
        storePath = path ?? ""
    }
}
