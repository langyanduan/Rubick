//
//  Updatable.swift
//  Rubick
//
//  Created by WuFan on 16/9/27.
//
//

import Foundation

protocol Updatable {
    @discardableResult
    func update(fromBytes bytes: UnsafeRawPointer, count: Int) -> Self
    
    func final() -> [UInt8]
}

extension Updatable {
    @discardableResult
    func update(fromData data: Data) -> Self {
        return self
    }
    
    @discardableResult
    func update(fromStream stream: InputStream) -> Self {
        return self
    }
}
