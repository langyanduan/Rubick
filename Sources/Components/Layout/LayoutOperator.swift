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
        item.view.dsl.centerX == otherItem.view.dsl.centerX,
        item.view.dsl.centerY == otherItem.view.dsl.centerY,
    ])
}
public func ==(item: LayoutCenterItem, convertible: ViewDSLConvertible) -> LayoutConstraintGroup {
    return item == convertible.asViewLayoutDSL().center
}

// size
public func ==(item: LayoutSizeItem, otherItem: LayoutSizeItem) -> LayoutConstraintGroup {
    return LayoutConstraintGroup(collection: [
        item.view.dsl.width == otherItem.view.dsl.width,
        item.view.dsl.height == otherItem.view.dsl.height,
    ])
}
public func ==(item: LayoutSizeItem, size: CGSize) -> LayoutConstraintGroup {
    return LayoutConstraintGroup(collection: [
        item.view.dsl.width == size.width,
        item.view.dsl.height == size.height,
    ])
}
public func ==(item: LayoutSizeItem, convertible: ViewDSLConvertible) -> LayoutConstraintGroup {
    return item == convertible.asViewLayoutDSL().size
}

// edges
public func ==(item: LayoutEdgesItem, otherItem: LayoutEdgesItem) -> LayoutConstraintGroup {
    return LayoutConstraintGroup(collection: [
        item.view.dsl.left == otherItem.view.dsl.left + otherItem.insets.left,
        item.view.dsl.right == otherItem.view.dsl.right - otherItem.insets.right,
        item.view.dsl.top == otherItem.view.dsl.top + otherItem.insets.top,
        item.view.dsl.bottom == otherItem.view.dsl.bottom - otherItem.insets.bottom,
    ])
}
public func ==(item: LayoutEdgesItem, insets: UIEdgeInsets) -> LayoutConstraintGroup {
    guard let superview = item.view.superview else { fatalError() }
    return LayoutConstraintGroup(collection: [
        item.view.dsl.left == superview.dsl.left + insets.left,
        item.view.dsl.right == superview.dsl.right - insets.right,
        item.view.dsl.top == superview.dsl.top + insets.top,
        item.view.dsl.bottom == superview.dsl.bottom - insets.bottom,
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
