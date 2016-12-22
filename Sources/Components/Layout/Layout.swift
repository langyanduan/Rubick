//
//  AutolayoutDSL.swift
//  Rubick
//
//  Created by WuFan on 2016/10/19.
//
//

import Foundation
import UIKit

// generate constraint
extension LayoutConstraint {
    func asConstraint() -> NSLayoutConstraint {
        let constraint = DSLLayoutConstraint(
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

extension LayoutConstraintGroup {
    func asConstraints() -> [NSLayoutConstraint] {
        return collection.map { $0.asConstraint() }
    }
}

public protocol NSLayoutConstraintConvertible {}
extension LayoutConstraint: NSLayoutConstraintConvertible {}
extension LayoutConstraintGroup: NSLayoutConstraintConvertible {}

public func activateLayoutConstraints(_ convertibles: [NSLayoutConstraintConvertible]) {
    var constraints: [NSLayoutConstraint] = []
    for convertible in convertibles {
        switch convertible {
        case let dsl as LayoutConstraint:
            constraints.append(dsl.asConstraint())
        case let group as LayoutConstraintGroup:
            constraints += group.asConstraints()
        default:
            assertionFailure()
        }
    }
    
    NSLayoutConstraint.activate(constraints)
}

public func activateLayoutConstraints(_ view1: UIView, _ convertibles: (ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.DSL))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ convertibles: (ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.DSL, view2.DSL))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.DSL, view2.DSL, view3.DSL))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.DSL, view2.DSL, view3.DSL, view4.DSL))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.DSL, view2.DSL, view3.DSL, view4.DSL, view5.DSL))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.DSL, view2.DSL, view3.DSL, view4.DSL, view5.DSL, view6.DSL))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ view7: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.DSL, view2.DSL, view3.DSL, view4.DSL, view5.DSL, view6.DSL, view7.DSL))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ view7: UIView, _ view8: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.DSL, view2.DSL, view3.DSL, view4.DSL, view5.DSL, view6.DSL, view7.DSL, view8.DSL))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ view7: UIView, _ view8: UIView, _ view9: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.DSL, view2.DSL, view3.DSL, view4.DSL, view5.DSL, view6.DSL, view7.DSL, view8.DSL, view9.DSL))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ view7: UIView, _ view8: UIView, _ view9: UIView, _ view10: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.DSL, view2.DSL, view3.DSL, view4.DSL, view5.DSL, view6.DSL, view7.DSL, view8.DSL, view9.DSL, view10.DSL))
}
