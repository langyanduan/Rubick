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
    public var left: LayoutItem { return LayoutItem(view: self, attribute: .left) }
    public var right: LayoutItem { return LayoutItem(view: self, attribute: .right) }
    public var top: LayoutItem { return LayoutItem(view: self, attribute: .top) }
    public var bottom: LayoutItem { return LayoutItem(view: self, attribute: .bottom) }
    public var width: LayoutItem { return LayoutItem(view: self, attribute: .width) }
    public var height: LayoutItem { return LayoutItem(view: self, attribute: .height) }
    public var centerX: LayoutItem { return LayoutItem(view: self, attribute: .centerX) }
    public var centerY: LayoutItem { return LayoutItem(view: self, attribute: .centerY) }
    public var lastBaseline: LayoutItem { return LayoutItem(view: self, attribute: .lastBaseline) }
    public var firstBaseline: LayoutItem { return LayoutItem(view: self, attribute: .firstBaseline) }
}

public struct LayoutItem {
    let view: UIView
    let attribute: NSLayoutAttribute
}

public struct LayoutCondition {
    fileprivate let view: UIView?
    fileprivate let attribute: NSLayoutAttribute
    fileprivate var constant: CGFloat
    fileprivate var multiplier: CGFloat = 1
    fileprivate var priority: UILayoutPriority = UILayoutPriorityRequired
    
    fileprivate init(view: UIView?, attribute: NSLayoutAttribute, constant: CGFloat = 0) {
        self.view = view
        self.attribute = attribute
        self.constant = constant
    }
}

public struct LayoutConstraintDSL {
    fileprivate let firstItem: UIView
    fileprivate let firstAttribute: NSLayoutAttribute
    fileprivate let relation: NSLayoutRelation
    fileprivate let secondItem: UIView?
    fileprivate let secondAttribute: NSLayoutAttribute
    fileprivate let constant: CGFloat
    fileprivate let multiplier: CGFloat
    fileprivate var priority: UILayoutPriority
}

// convertible
public protocol LayoutConditionConvertible {
    func asLayoutCondition() -> LayoutCondition
}

extension LayoutCondition: LayoutConditionConvertible {
    public func asLayoutCondition() -> LayoutCondition {
        return self
    }
}

extension LayoutItem: LayoutConditionConvertible {
    public func asLayoutCondition() -> LayoutCondition {
        return LayoutCondition(view: view, attribute: attribute)
    }
}

extension CGFloat: LayoutConditionConvertible {
    public func asLayoutCondition() -> LayoutCondition {
        return LayoutCondition(view: nil, attribute: .notAnAttribute, constant: CGFloat(self))
    }
}

extension Int: LayoutConditionConvertible {
    public func asLayoutCondition() -> LayoutCondition {
        return LayoutCondition(view: nil, attribute: .notAnAttribute, constant: CGFloat(self))
    }
}

// operator
public func *(convertible: LayoutConditionConvertible, multiplier: CGFloat) -> LayoutCondition {
    var condition = convertible.asLayoutCondition()
    condition.multiplier = multiplier
    return condition
}

public func +(convertible: LayoutConditionConvertible, constant: CGFloat) -> LayoutCondition {
    var condition = convertible.asLayoutCondition()
    condition.constant += constant
    return condition
}

public func -(convertible: LayoutConditionConvertible, constant: CGFloat) -> LayoutCondition {
    var condition = convertible.asLayoutCondition()
    condition.constant -= constant
    return condition
}

precedencegroup DSLPriorityPrecedence {
    associativity: left
    higherThan: ComparisonPrecedence
}
infix operator ~: DSLPriorityPrecedence
public func ~(convertible: LayoutConditionConvertible, priority: UILayoutPriority) -> LayoutCondition {
    var condition = convertible.asLayoutCondition()
    condition.priority = priority
    return condition
}

// generate constraint
extension LayoutConstraintDSL {
    init(item: LayoutItem, layoutCondition: LayoutCondition, relatedBy relation: NSLayoutRelation) {
        self.firstItem = item.view
        self.firstAttribute = item.attribute
        self.relation = relation
        self.secondItem = layoutCondition.view
        self.secondAttribute = layoutCondition.attribute
        self.constant = layoutCondition.constant
        self.multiplier = layoutCondition.multiplier
        self.priority = layoutCondition.priority
    }
    func asConstraint() -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )
        constraint.priority = priority
        return constraint
    }
}

public func ==(item: LayoutItem, condition: LayoutConditionConvertible) -> LayoutConstraintDSL {
    return LayoutConstraintDSL(item: item, layoutCondition: condition.asLayoutCondition(), relatedBy: .equal)
}

public func >=(item: LayoutItem, condition: LayoutConditionConvertible) -> LayoutConstraintDSL {
    return LayoutConstraintDSL(item: item, layoutCondition: condition.asLayoutCondition(), relatedBy: .greaterThanOrEqual)
}

public func <=(item: LayoutItem, condition: LayoutConditionConvertible) -> LayoutConstraintDSL {
    return LayoutConstraintDSL(item: item, layoutCondition: condition.asLayoutCondition(), relatedBy: .lessThanOrEqual)
}

public func activateLayoutConstraints(_ constraints: [LayoutConstraintDSL]) {
    NSLayoutConstraint.activate( constraints.map { $0.asConstraint() } )
}
