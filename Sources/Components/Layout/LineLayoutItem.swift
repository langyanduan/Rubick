//
//  LineLayoutItem.swift
//  Rubick
//
//  Created by WuFan on 2016/10/25.
//
//

import Foundation
import UIKit

public enum LayoutValue {
    case view(UIView)
    case value(CGFloat)
}
public protocol LayoutValueConvertible {
    func asLayoutValue() -> LayoutValue
}
extension UIView: LayoutValueConvertible {
    public func asLayoutValue() -> LayoutValue {
        return .view(self)
    }
}
extension CGFloat: LayoutValueConvertible {
    public func asLayoutValue() -> LayoutValue {
        return .value(self)
    }
}
extension Int: LayoutValueConvertible {
    public func asLayoutValue() -> LayoutValue {
        return .value(self.asCGFloat)
    }
}


public enum LayoutValueRelation {
    case lessThanOrEqual(LayoutValue)
    case greaterThanOrEqual(LayoutValue)
    case equal(LayoutValue)
}
extension LayoutValueRelation {
    var relation: NSLayoutRelation {
        switch self {
        case .lessThanOrEqual:
            return .lessThanOrEqual
        case .greaterThanOrEqual:
            return .greaterThanOrEqual
        case .equal:
            return .equal
        }
    }
    
    var value: LayoutValue {
        switch self {
        case let .lessThanOrEqual(value),
             let .greaterThanOrEqual(value),
             let .equal(value):
            return value
        }
    }
}

public enum LineLayoutItem {
    case lessThanOrEqual(CGFloatConvertible)
    case greaterThanOrEqual(CGFloatConvertible)
    case equal(CGFloatConvertible)
    case view(UIView)
    case viewRelation(UIView, LayoutValueRelation)
}
public protocol LineLayoutItemConvertible {
    func asLineLayoutItem() -> LineLayoutItem
}
extension LineLayoutItem: LineLayoutItemConvertible {
    public func asLineLayoutItem() -> LineLayoutItem {
        return self
    }
}
extension UIView: LineLayoutItemConvertible {
    public func asLineLayoutItem() -> LineLayoutItem {
        return .view(self)
    }
}

