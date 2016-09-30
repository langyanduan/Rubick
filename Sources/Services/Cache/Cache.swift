//
//  Cache.swift
//  Rubick
//
//  Created by WuFan on 16/9/19.
//
//

import Foundation

public protocol CacheProtocol {
    associatedtype Element
    
    func containsObject(forKey key: String) -> Bool
    func object(forKey key: String) -> Element?
    func setObject(_ object: Element, forKey key: String)
    
    func removeObject(forKey key: String)
    func removeAllObjects()
}

public protocol AsyncCacheProtocol {
    var asyncQueue: DispatchQueue { get }
}

public struct AsyncCache<Base: CacheProtocol> {
    public typealias Element = Base.Element
    
    fileprivate let base: Base
    fileprivate init(_ base: Base) {
        self.base = base
    }
}

extension AsyncCache where Base: AsyncCacheProtocol {
    private func async(execute code: @escaping () -> Void) {
        base.asyncQueue.async(execute: code)
    }
    
    public func containsObject(forKey key: String, _ closure:  @escaping (Bool) -> Void) {
        async {
            closure(self.base.containsObject(forKey: key))
        }
    }
    
    public func object(forKey key: String, _ closure: @escaping (Element?) -> Void) {
        async { 
            closure(self.base.object(forKey: key))
        }
    }
    
    public func setObject(_ object: Element, forKey key: String) {
        async { 
            self.base.setObject(object, forKey: key)
        }
    }
    
    public func removeObject(forKey key: String) {
        async { 
            self.base.removeObject(forKey: key)
        }
    }
    
    public func removeAllObjects() {
        async { 
            self.base.removeAllObjects()
        }
    }
}

extension AsyncCacheProtocol where Self: CacheProtocol {
    public var async: AsyncCache<Self> {
        return AsyncCache(self)
    }
}

//extension CacheProtocol where Self: AsyncCacheProtocol {
//    public var async: AsyncCache<Self> {
//        return AsyncCache(self)
//    }
//}


public protocol CacheSerializerProtocol {
    associatedtype T
    
    func data(forObject object: T) throws -> Data
    func object(forData data: Data) throws -> T
}

public class CacheSerializer<T>: CacheSerializerProtocol {
    public func data(forObject object: T) throws -> Data {
        fatalError("subclass should implement this method.")
    }
    
    public func object(forData data: Data) throws -> T {
        fatalError("subclass should implement this method.")
    }
}


