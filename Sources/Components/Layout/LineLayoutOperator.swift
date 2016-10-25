//
//  LineLayoutOperator.swift
//  Rubick
//
//  Created by WuFan on 2016/10/25.
//
//

import Foundation
import UIKit

prefix operator <=
prefix operator >=
prefix operator ==

public prefix func <=(value: CGFloatConvertible) -> LineLayoutItem {
    return .lessThanOrEqual(value)
}
public prefix func >=(value: CGFloatConvertible) -> LineLayoutItem {
    return .greaterThanOrEqual(value)
}
public prefix func ==(value: CGFloatConvertible) -> LineLayoutItem {
    return .equal(value)
}

//infix operator =~: ComparisonPrecedence
public func ==(view: UIView, value: LayoutValueConvertible) -> LineLayoutItem {
    return .viewRelation(view, .equal(value.asLayoutValue()))
}
public func >=(view: UIView, value: LayoutValueConvertible) -> LineLayoutItem {
    return .viewRelation(view, .greaterThanOrEqual(value.asLayoutValue()))
}
public func <=(view: UIView, value: LayoutValueConvertible) -> LineLayoutItem {
    return .viewRelation(view, .lessThanOrEqual(value.asLayoutValue()))
}
