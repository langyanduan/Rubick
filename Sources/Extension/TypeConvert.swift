//
//  TypeConvert.swift
//  Rubick
//
//  Created by wufan on 16/8/25.
//
//

import Foundation

public protocol CGFloatConvertible {
    var asCGFloat: CGFloat { get }
}

public protocol Int64Convertible {
    var asInt64: Int64 { get }
}

extension CGFloat: CGFloatConvertible {
    public var asCGFloat: CGFloat {
        return self
    }
}

extension Float: CGFloatConvertible {
    public var asCGFloat: CGFloat {
        return CGFloat(self)
    }
}

extension Int: CGFloatConvertible, Int64Convertible {
    public var asCGFloat: CGFloat {
        return CGFloat(self)
    }
    
    public var asInt64: Int64 {
        return Int64(self)
    }
}

