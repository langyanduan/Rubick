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

public protocol TypeExtensibility {
    associatedtype ExtensibilityType
    static var smt: TypeExtension<ExtensibilityType> { get }
}
public extension TypeExtensibility {
    public static var smt: TypeExtension<Self> {
        return TypeExtension()
    }
}
public protocol InstanceExtensibility {
    associatedtype ExtensibilityType
    var ext: InstanceExtension<ExtensibilityType> { get }
}

public extension InstanceExtensibility {
    public var ext: InstanceExtension<Self> {
        return InstanceExtension(self)
    }
}

// MARK: class

extension UIView: InstanceExtensibility {}
extension UIImage: InstanceExtensibility {}
extension UIColor: InstanceExtensibility {}
extension UIColor: TypeExtensibility {}

// MARK: struct

public protocol _ArrayType: InstanceExtensibility {
    associatedtype Element
}
extension Array: _ArrayType {}






