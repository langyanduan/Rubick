//
//  Extension.swift
//  Rubick
//
//  Created by WuFan on 16/9/9.
//
//

import Foundation
import UIKit

// MARK: swifty extension
public struct TypeExtension<Base: Any> { }
public struct InstanceExtension<Base: Any> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol TypeCompatible {
    associatedtype CompatibleType
    static var ext: TypeExtension<CompatibleType> { get }
}
public extension TypeCompatible {
    public static var ext: TypeExtension<Self> {
        return TypeExtension()
    }
}
public protocol InstanceCompatible {
    associatedtype CompatibleType
    var ext: InstanceExtension<CompatibleType> { get }
}

public extension InstanceCompatible {
    public var ext: InstanceExtension<Self> {
        return InstanceExtension(self)
    }
}

// MARK: class

extension UIView: InstanceCompatible {}
extension UIImage: InstanceCompatible {}
extension UIColor: InstanceCompatible {}
extension UIColor: TypeCompatible {}

// MARK: struct

public protocol _ArrayType: InstanceCompatible { associatedtype Element }
extension Array: _ArrayType {}

public protocol _StringType: InstanceCompatible {}
extension String: _StringType {}

