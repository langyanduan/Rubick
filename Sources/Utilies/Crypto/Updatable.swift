//
//  Updatable.swift
//  Rubick
//
//  Created by WuFan on 16/9/27.
//
//

import Foundation

public protocol Updatable {
    @discardableResult
    func update(fromBytes bytes: UnsafeRawPointer, count: Int) -> Self
    
    func final() -> [UInt8]
}

public extension Updatable {
    @discardableResult
    func update(fromData data: Data) -> Self {
        return update(fromBytes: (data as NSData).bytes, count: data.count)
    }
    
    @discardableResult
    func update(fromStream stream: InputStream) -> Self {
        stream.open(); defer { stream.close() }
        
        let maxLength = 32
        var buffer = [UInt8](repeating: 0, count: maxLength)
        while true {
            let length = stream.read(&buffer, maxLength: maxLength)
            guard length > 0 else { break }
            update(fromBytes: buffer, count: length)
        }
        
        return self
    }
    
    @discardableResult
    func update(fromBytes bytes: [UInt8]) -> Self {
        return update(fromBytes: bytes, count: bytes.count)
    }
}
