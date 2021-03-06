//
//  Array+Extension.swift
//  Rubick
//
//  Created by wufan on 16/8/19.
//
//

import Foundation

extension InstanceExtension where Base: _ArrayType {
    private var _self: Array<Base.Element> {
        return base as! Array<Base.Element>
    }
    
    public func forEachPair(_ clousre: (Base.Element, Base.Element) -> Void) {
        guard _self.count > 1 else {
            return
        }
        for index in 0 ..< _self.count - 1 {
            let item1 = _self[index]
            let item2 = _self[index + 1]
            clousre(item1, item2)
        }
    }
}

extension InstanceExtension where Base: _ArrayType, Base.Element == UInt8 {
    private var _self: Array<Base.Element> {
        return base as! Array<Base.Element>
    }
    
    public func hexString(uppercase: Bool = true) -> String {
        if uppercase {
            return _self
                .map { String(format: "%02X", $0) }
                .reduce("", +)
        } else {
            return _self
                .map { String(format: "%02x", $0) }
                .reduce("", +)
        }
    }
}
