//
//  LayoutOperator.swift
//  Rubick
//
//  Created by WuFan on 2016/10/25.
//
//

import Foundation
import UIKit

infix operator ~: AdditionPrecedence

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

// item
public func ==(item: LayoutItem, condition: LayoutConditionConvertible) -> LayoutConstraint {
    return LayoutConstraint(item: item, layoutCondition: condition.asLayoutCondition(), relatedBy: .equal)
}
public func ==(item: LayoutItem, convertible: ViewDSLConvertible) -> LayoutConstraint {
    return item == LayoutItem(view: convertible.asViewLayoutDSL().base, attribute: item.attribute)
}
public func >=(item: LayoutItem, condition: LayoutConditionConvertible) -> LayoutConstraint {
    return LayoutConstraint(item: item, layoutCondition: condition.asLayoutCondition(), relatedBy: .greaterThanOrEqual)
}
public func >=(item: LayoutItem, convertible: ViewDSLConvertible) -> LayoutConstraint {
    return item >= LayoutItem(view: convertible.asViewLayoutDSL().base, attribute: item.attribute)
}
public func <=(item: LayoutItem, condition: LayoutConditionConvertible) -> LayoutConstraint {
    return LayoutConstraint(item: item, layoutCondition: condition.asLayoutCondition(), relatedBy: .lessThanOrEqual)
}
public func <=(item: LayoutItem, convertible: ViewDSLConvertible) -> LayoutConstraint {
    return item <= LayoutItem(view: convertible.asViewLayoutDSL().base, attribute: item.attribute)
}

// DSL priority
public func ~(constraint: LayoutConstraint, priority: UILayoutPriority) -> LayoutConstraint {
    var constraint = constraint
    constraint.priority = priority
    return constraint
}


// center
public func ==(item: LayoutCenterItem, otherItem: LayoutCenterItem) -> LayoutConstraintGroup {
    return LayoutConstraintGroup(collection: [
        item.view.DSL.centerX == otherItem.view.DSL.centerX,
        item.view.DSL.centerY == otherItem.view.DSL.centerY,
    ])
}
public func ==(item: LayoutCenterItem, convertible: ViewDSLConvertible) -> LayoutConstraintGroup {
    return item == convertible.asViewLayoutDSL().center
}

// size
public func ==(item: LayoutSizeItem, otherItem: LayoutSizeItem) -> LayoutConstraintGroup {
    return LayoutConstraintGroup(collection: [
        item.view.DSL.width == otherItem.view.DSL.width,
        item.view.DSL.height == otherItem.view.DSL.height,
    ])
}
public func ==(item: LayoutSizeItem, size: CGSize) -> LayoutConstraintGroup {
    return LayoutConstraintGroup(collection: [
        item.view.DSL.width == size.width,
        item.view.DSL.height == size.height,
    ])
}
public func ==(item: LayoutSizeItem, convertible: ViewDSLConvertible) -> LayoutConstraintGroup {
    return item == convertible.asViewLayoutDSL().size
}

// edges
public func ==(item: LayoutEdgesItem, otherItem: LayoutEdgesItem) -> LayoutConstraintGroup {
    return LayoutConstraintGroup(collection: [
        item.view.DSL.left == otherItem.view.DSL.left + otherItem.insets.left,
        item.view.DSL.right == otherItem.view.DSL.right - otherItem.insets.right,
        item.view.DSL.top == otherItem.view.DSL.top + otherItem.insets.top,
        item.view.DSL.bottom == otherItem.view.DSL.bottom - otherItem.insets.bottom,
    ])
}
public func ==(item: LayoutEdgesItem, insets: UIEdgeInsets) -> LayoutConstraintGroup {
    guard let superview = item.view.superview else { fatalError() }
    return LayoutConstraintGroup(collection: [
        item.view.DSL.left == superview.DSL.left + insets.left,
        item.view.DSL.right == superview.DSL.right - insets.right,
        item.view.DSL.top == superview.DSL.top + insets.top,
        item.view.DSL.bottom == superview.DSL.bottom - insets.bottom,
    ])
}
public func ==(item: LayoutEdgesItem, convertible: ViewDSLConvertible) -> LayoutConstraintGroup {
    return item == convertible.asViewLayoutDSL().edges
}

// DSL group priority
public func ~(constraintDSLCollection: LayoutConstraintGroup, priority: UILayoutPriority) -> LayoutConstraintGroup {
    var constraintDSLCollection = constraintDSLCollection
    for i in 0..<constraintDSLCollection.collection.count {
        constraintDSLCollection.collection[i].priority = priority
    }
    return constraintDSLCollection
}
