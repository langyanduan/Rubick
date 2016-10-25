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
    activateLayoutConstraints(convertibles(view1.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ convertibles: (ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl, view4.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl, view4.dsl, view5.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl, view4.dsl, view5.dsl, view6.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ view7: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl, view4.dsl, view5.dsl, view6.dsl, view7.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ view7: UIView, _ view8: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl, view4.dsl, view5.dsl, view6.dsl, view7.dsl, view8.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ view7: UIView, _ view8: UIView, _ view9: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl, view4.dsl, view5.dsl, view6.dsl, view7.dsl, view8.dsl, view9.dsl))
}
public func activateLayoutConstraints(_ view1: UIView, _ view2: UIView, _ view3: UIView, _ view4: UIView, _ view5: UIView, _ view6: UIView, _ view7: UIView, _ view8: UIView, _ view9: UIView, _ view10: UIView, _ convertibles: (ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL, ViewDSL) -> [NSLayoutConstraintConvertible]) {
    activateLayoutConstraints(convertibles(view1.dsl, view2.dsl, view3.dsl, view4.dsl, view5.dsl, view6.dsl, view7.dsl, view8.dsl, view9.dsl, view10.dsl))
}
