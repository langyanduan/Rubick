//
//  AutolayoutDSL.swift
//  Rubick
//
//  Created by WuFan on 2016/10/19.
//
//

import Foundation
import UIKit

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

public struct LayoutConstraintDSLCollection {
    fileprivate var collection: [LayoutConstraintDSL]
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

infix operator ~: AdditionPrecedence
public func ~(constraintDSL: LayoutConstraintDSL, priority: UILayoutPriority) -> LayoutConstraintDSL {
    var constraintDSL = constraintDSL
    constraintDSL.priority = priority
    return constraintDSL
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
        firstItem.translatesAutoresizingMaskIntoConstraints = false
        constraint.priority = priority
        return constraint
    }
}

extension LayoutConstraintDSLCollection {
    func asConstraint() -> [NSLayoutConstraint] {
        return collection.map { $0.asConstraint() }
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

public struct LayoutCenterItem {
    let view: UIView
}
public func ==(item: LayoutCenterItem, otherItem: LayoutCenterItem) -> LayoutConstraintDSLCollection {
    return LayoutConstraintDSLCollection(collection: [
        item.view.centerX == otherItem.view.centerX,
        item.view.centerY == otherItem.view.centerY,
    ])
}
public func ~(constraintDSLCollection: LayoutConstraintDSLCollection, priority: UILayoutPriority) -> LayoutConstraintDSLCollection {
    var constraintDSLCollection = constraintDSLCollection
    for i in 0..<constraintDSLCollection.collection.count {
        constraintDSLCollection.collection[i].priority = priority
    }
    return constraintDSLCollection
}

public struct LayoutEdgesItem {
    let view: UIView
    let insets: UIEdgeInsets
    
    init(view: UIView, insets: UIEdgeInsets = .zero) {
        self.view = view
        self.insets = insets
    }
}
public func ==(item: LayoutEdgesItem, otherItem: LayoutEdgesItem) -> LayoutConstraintDSLCollection {
    return LayoutConstraintDSLCollection(collection: [
        item.view.left == otherItem.view.left + otherItem.insets.left,
        item.view.right == otherItem.view.right - otherItem.insets.right,
        item.view.top == otherItem.view.top + otherItem.insets.top,
        item.view.bottom == otherItem.view.bottom - otherItem.insets.bottom,
    ])
}
public func ==(item: LayoutEdgesItem, insets: UIEdgeInsets) -> LayoutConstraintDSLCollection {
    guard let superview = item.view.superview else { fatalError() }
    return LayoutConstraintDSLCollection(collection: [
        item.view.left == superview.left + insets.left,
        item.view.right == superview.right - insets.right,
        item.view.top == superview.top + insets.top,
        item.view.bottom == superview.bottom - insets.bottom,
    ])
}

public struct ViewLayoutDSL {
    fileprivate let base: UIView
    
    public var left: LayoutItem { return LayoutItem(view: base, attribute: .left) }
    public var right: LayoutItem { return LayoutItem(view: base, attribute: .right) }
    public var top: LayoutItem { return LayoutItem(view: base, attribute: .top) }
    public var bottom: LayoutItem { return LayoutItem(view: base, attribute: .bottom) }
    public var width: LayoutItem { return LayoutItem(view: base, attribute: .width) }
    public var height: LayoutItem { return LayoutItem(view: base, attribute: .height) }
    public var centerX: LayoutItem { return LayoutItem(view: base, attribute: .centerX) }
    public var centerY: LayoutItem { return LayoutItem(view: base, attribute: .centerY) }
    public var lastBaseline: LayoutItem { return LayoutItem(view: base, attribute: .lastBaseline) }
    public var firstBaseline: LayoutItem { return LayoutItem(view: base, attribute: .firstBaseline) }
    
    public var center: LayoutCenterItem { return LayoutCenterItem(view: base) }
    public var edges: LayoutEdgesItem { return LayoutEdgesItem(view: base) }
    
    public func insets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> LayoutEdgesItem {
        return LayoutEdgesItem(view: base, insets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
}

extension UIView {
    public var dsl: ViewLayoutDSL {
        return ViewLayoutDSL(base: self)
    }
}

extension UIView {
    public var left: LayoutItem { return dsl.left }
    public var right: LayoutItem { return dsl.right }
    public var top: LayoutItem { return dsl.top }
    public var bottom: LayoutItem { return dsl.bottom }
    public var width: LayoutItem { return dsl.width }
    public var height: LayoutItem { return dsl.height }
    public var centerX: LayoutItem { return dsl.centerX }
    public var centerY: LayoutItem { return dsl.centerY }
    public var lastBaseline: LayoutItem { return dsl.lastBaseline }
    public var firstBaseline: LayoutItem { return dsl.firstBaseline }
}


public protocol NSLayoutConstraintConvertible { }

extension LayoutConstraintDSL: NSLayoutConstraintConvertible {}
extension LayoutConstraintDSLCollection: NSLayoutConstraintConvertible {}

public func activateLayoutConstraints(_ convertibles: [NSLayoutConstraintConvertible]) {
    var constraints: [NSLayoutConstraint] = []
    for convertible in convertibles {
        switch convertible {
        case let dsl as LayoutConstraintDSL:
            constraints.append(dsl.asConstraint())
        case let collection as LayoutConstraintDSLCollection:
            constraints += collection.asConstraint()
        default:
            assertionFailure()
        }
    }
    
    NSLayoutConstraint.activate(constraints)
}

public func activateLayoutConstraints(_ view1: UIView, _ convertibles: (ViewLayoutDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ convertibles: (ViewLayoutDSL, ViewLayoutDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ convertibles: (ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ convertibles: (ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl, view4.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ convertibles: (ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl, view4.dsl, view5.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ convertibles: (ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl, view4.dsl, view5.dsl, view6.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ view7: UIView, _ convertibles: (ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl, view4.dsl, view5.dsl, view6.dsl, view7.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ view7: UIView, _ view8: UIView, _ convertibles: (ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl, view4.dsl, view5.dsl, view6.dsl, view7.dsl, view8.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ view7: UIView, _ view8: UIView, _ view9: UIView, _ convertibles: (ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl, view4.dsl, view5.dsl, view6.dsl, view7.dsl, view8.dsl, view9.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ view7: UIView, _ view8: UIView, _ view9: UIView, _ view10: UIView, _ convertibles: (ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL, ViewLayoutDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl, view4.dsl, view5.dsl, view6.dsl, view7.dsl, view8.dsl, view9.dsl, view10.dsl))
}
