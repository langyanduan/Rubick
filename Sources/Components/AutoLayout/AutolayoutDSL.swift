//
//  AutolayoutDSL.swift
//  Rubick
//
//  Created by WuFan on 2016/10/19.
//
//

import Foundation
import UIKit

extension UIView {
    var left: ConstraintItem { return ConstraintItem(view: self, attribute: .left) }
    var right: ConstraintItem { return ConstraintItem(view: self, attribute: .right) }
    var top: ConstraintItem { return ConstraintItem(view: self, attribute: .top) }
    var bottom: ConstraintItem { return ConstraintItem(view: self, attribute: .bottom) }
    var width: ConstraintItem { return ConstraintItem(view: self, attribute: .width) }
    var height: ConstraintItem { return ConstraintItem(view: self, attribute: .height) }
    var centerX: ConstraintItem { return ConstraintItem(view: self, attribute: .centerX) }
    var centerY: ConstraintItem { return ConstraintItem(view: self, attribute: .centerY) }
    var lastBaseline: ConstraintItem { return ConstraintItem(view: self, attribute: .lastBaseline) }
    var firstBaseline: ConstraintItem { return ConstraintItem(view: self, attribute: .firstBaseline) }
}

public struct ConstraintItem {
    let view: UIView
    let attribute: NSLayoutAttribute
}

public struct ConstraintDSL {
    fileprivate let view: UIView?
    fileprivate let attribute: NSLayoutAttribute
    fileprivate var constant: CGFloat
    fileprivate var multiplier: CGFloat = 1
    
    fileprivate init(view: UIView?, attribute: NSLayoutAttribute, constant: CGFloat = 0) {
        self.view = view
        self.attribute = attribute
        self.constant = constant
    }
}

// convertible
public protocol ConstraintDSLConvertible {
    func asConstraintDSL() -> ConstraintDSL
}

extension ConstraintDSL: ConstraintDSLConvertible {
    public func asConstraintDSL() -> ConstraintDSL {
        return self
    }
}

extension ConstraintItem: ConstraintDSLConvertible {
    public func asConstraintDSL() -> ConstraintDSL {
        return ConstraintDSL(view: view, attribute: attribute)
    }
}

extension CGFloat: ConstraintDSLConvertible {
    public func asConstraintDSL() -> ConstraintDSL {
        return ConstraintDSL(view: nil, attribute: .notAnAttribute, constant: CGFloat(self))
    }
}

extension Int: ConstraintDSLConvertible {
    public func asConstraintDSL() -> ConstraintDSL {
        return ConstraintDSL(view: nil, attribute: .notAnAttribute, constant: CGFloat(self))
    }
}

// operator
public func *(dsl: ConstraintDSLConvertible, multiplier: CGFloat) -> ConstraintDSL {
    var constraintDSL = dsl.asConstraintDSL()
    constraintDSL.multiplier = multiplier
    return constraintDSL
}

public func +(dsl: ConstraintDSLConvertible, constant: CGFloat) -> ConstraintDSL {
    var constraintDSL = dsl.asConstraintDSL()
    constraintDSL.constant += constant
    return constraintDSL
}

public func -(dsl: ConstraintDSLConvertible, constant: CGFloat) -> ConstraintDSL {
    var constraintDSL = dsl.asConstraintDSL()
    constraintDSL.constant -= constant
    return constraintDSL
}

// generate constraint
public func ==(item: ConstraintItem, dsl: ConstraintDSLConvertible) -> NSLayoutConstraint {
    let constraintDSL = dsl.asConstraintDSL()
    let constraint = NSLayoutConstraint(item: item.view, attribute: item.attribute, relatedBy: .equal, toItem: constraintDSL.view, attribute: constraintDSL.attribute, multiplier: constraintDSL.multiplier, constant: constraintDSL.constant)
    return constraint
}

public func >=(item: ConstraintItem, dsl: ConstraintDSLConvertible) -> NSLayoutConstraint {
    let constraintDSL = dsl.asConstraintDSL()
    let constraint = NSLayoutConstraint(item: item.view, attribute: item.attribute, relatedBy: .greaterThanOrEqual, toItem: constraintDSL.view, attribute: constraintDSL.attribute, multiplier: constraintDSL.multiplier, constant: constraintDSL.constant)
    return constraint
}

public func <=(item: ConstraintItem, dsl: ConstraintDSLConvertible) -> NSLayoutConstraint {
    let constraintDSL = dsl.asConstraintDSL()
    let constraint = NSLayoutConstraint(item: item.view, attribute: item.attribute, relatedBy: .lessThanOrEqual, toItem: constraintDSL.view, attribute: constraintDSL.attribute, multiplier: constraintDSL.multiplier, constant: constraintDSL.constant)
    return constraint
}

precedencegroup DSLPriorityPrecedence {
    associativity: left
    lowerThan: ComparisonPrecedence
}
infix operator ~: DSLPriorityPrecedence
public func ~(constraint: NSLayoutConstraint, priority: UILayoutPriority) -> NSLayoutConstraint {
    constraint.priority = priority
    return constraint
}
