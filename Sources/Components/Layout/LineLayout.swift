//
//  LineLayout.swift
//  Rubick
//
//  Created by WuFan on 2016/10/19.
//
//

import Foundation
import UIKit

// build constraints
private func buildOptionConstraints(for view: UIView, axis: UILayoutConstraintAxis, options: [LineLayoutOption]) -> [NSLayoutConstraint] {
    func firstAttribute(with axis: UILayoutConstraintAxis, option: LineLayoutOption) -> NSLayoutAttribute {
        switch option {
        case .center:
            return axis == .horizontal ? .centerY : .centerX
        case .head:
            return axis == .horizontal ? .top : .left
        case .tail:
            return axis == .horizontal ? .bottom : .right
        default:
            fatalError()
        }
    }
    func secondAttribute(with axis: UILayoutConstraintAxis, attribute: LineLayoutOption.Attribute) -> NSLayoutAttribute {
        switch attribute {
        case .center:
            return axis == .horizontal ? .centerY : .centerX
        case .head:
            return axis == .horizontal ? .top : .left
        case .tail:
            return axis == .horizontal ? .bottom : .right
        }
    }
    func constantAttribute(with option: LineLayoutOption) -> NSLayoutAttribute {
        switch option {
        case .width:
            return .width
        case .height:
            return .height
        default:
            fatalError()
        }
    }
    var constraints: [NSLayoutConstraint] = []
    for option in options {
        let constraint: NSLayoutConstraint
        switch option {
        case let .center(otherView, attribute),
             let .head(otherView, attribute),
             let .tail(otherView, attribute):
            constraint = DSLLayoutConstraint(
                item: view,
                attribute: firstAttribute(with: axis, option: option),
                relatedBy: .equal,
                toItem: otherView,
                attribute: secondAttribute(with: axis, attribute: attribute),
                multiplier: 1,
                constant: 0
            )
        case let .width(constant),
             let .height(constant):
            let attribute = constantAttribute(with: option)
            switch constant.value {
            case let .value(value):
                constraint = DSLLayoutConstraint(
                    item: view,
                    attribute: attribute,
                    relatedBy: constant.relation,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1,
                    constant: value
                )
            case let .view(otherView):
                constraint = DSLLayoutConstraint(
                    item: view,
                    attribute: attribute,
                    relatedBy: constant.relation,
                    toItem: otherView,
                    attribute: attribute,
                    multiplier: 1,
                    constant: 0
                )
            }
        case .equalWidth, .equalHeight:
            continue
        }
        constraints.append(constraint)
    }
    return constraints
}

private func buildLineLayoutConstraints(
    axis: UILayoutConstraintAxis,
    options: [LineLayoutOption] = [],
    first: LayoutItem,
    last: LayoutItem,
    items: [LineLayoutItemConvertible])
    -> [NSLayoutConstraint]
{
    assert(
        (axis == .horizontal &&
         Set<NSLayoutAttribute>(arrayLiteral: .left, .right, .centerX).isSuperset(of: Set(arrayLiteral: first.attribute, last.attribute)))
            ||
        (axis == .vertical &&
         Set<NSLayoutAttribute>(arrayLiteral: .top, .bottom, .centerY).isSuperset(of: Set(arrayLiteral: first.attribute, last.attribute)))
    )
    
    var constraints: [NSLayoutConstraint] = []
    var constant: CGFloat?
    var relation: NSLayoutRelation = .equal
    var prevLayoutItem: LayoutItem = first
    
    for item in items {
        let lineLayoutItem = item.asLineLayoutItem()
        
        switch lineLayoutItem {
        case .equal(let value):
            assert(constant == nil)
            constant = value.asCGFloat
            relation = .equal
        case .greaterThanOrEqual(let value):
            assert(constant == nil)
            constant = value.asCGFloat
            relation = .greaterThanOrEqual
        case .lessThanOrEqual(let value):
            assert(constant == nil)
            constant = value.asCGFloat
            relation = .lessThanOrEqual
        case .view(let view):
            constraints.append(DSLLayoutConstraint(
                item: view,
                attribute: axis == .vertical ? .top : .left,
                relatedBy: relation,
                toItem: prevLayoutItem.view,
                attribute: prevLayoutItem.attribute,
                multiplier: 1,
                constant: constant ?? 0)
            )
            constraints += buildOptionConstraints(for: view, axis: axis, options: options)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            constant = nil
            relation = .equal
            prevLayoutItem = LayoutItem(view: view, attribute: axis == .vertical ? .bottom : .right)
        case let .viewRelation(view, valueRelation):
            constraints.append(DSLLayoutConstraint(
                item: view,
                attribute: axis == .vertical ? .top : .left,
                relatedBy: relation,
                toItem: prevLayoutItem.view,
                attribute: prevLayoutItem.attribute,
                multiplier: 1,
                constant: constant ?? 0)
            )
            
            let attribute: NSLayoutAttribute = axis == .vertical ? .height : .width
            switch valueRelation.value {
            case .value(let value):
                constraints.append(DSLLayoutConstraint(
                    item: view,
                    attribute: attribute,
                    relatedBy: valueRelation.relation,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1,
                    constant: value)
                )
            case .view(let otherView):
                constraints.append(DSLLayoutConstraint(
                    item: view,
                    attribute: attribute,
                    relatedBy: valueRelation.relation,
                    toItem: otherView,
                    attribute: attribute,
                    multiplier: 1,
                    constant: 0)
                )
            }
            
            constraints += buildOptionConstraints(for: view, axis: axis, options: options)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            constant = nil
            relation = .equal
            prevLayoutItem = LayoutItem(view: view, attribute: axis == .vertical ? .bottom : .right)
        }
    }
    
    constraints.append(DSLLayoutConstraint(
        item: last.view,
        attribute: last.attribute,
        relatedBy: relation,
        toItem: prevLayoutItem.view,
        attribute: prevLayoutItem.attribute,
        multiplier: 1,
        constant: constant ?? 0)
    )
    
    var equalWidth = false, equalHeight = false
    options.forEach { (option) in
        switch option {
        case .equalHeight:
            equalHeight = true
        case .equalWidth:
            equalWidth = true
        default:
            break
        }
    }
    if equalWidth || equalHeight {
        let views = items.flatMap { (convertible) -> UIView? in
            switch convertible.asLineLayoutItem() {
            case .view(let view), .viewRelation(let view, _):
                return view
            default:
                return nil
            }
        }
        
        var lastView: UIView?
        for view in views {
            defer { lastView = view }
            guard let lastView = lastView else {
                continue
            }
            
            if equalWidth {
                constraints.append(DSLLayoutConstraint(
                    item: view,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: lastView,
                    attribute: .width,
                    multiplier: 1,
                    constant: 0)
                )
            }
            if equalHeight {
                constraints.append(DSLLayoutConstraint(
                    item: view,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: lastView,
                    attribute: .height,
                    multiplier: 1,
                    constant: 0)
                )
            }
        }
    }
    
    return constraints
}

// activate function
public func activateLineLayout(
    head first: LayoutItem,
    tail last: LayoutItem,
    axis: UILayoutConstraintAxis,
    options: [LineLayoutOption] = [],
    items: [LineLayoutItemConvertible])
{
    NSLayoutConstraint.activate(
        buildLineLayoutConstraints(axis: axis, options: options, first: first, last: last, items: items)
    )
}

public func activateLineLayout(
    in view: UIView,
    axis: UILayoutConstraintAxis,
    options: [LineLayoutOption] = [],
    items: [LineLayoutItemConvertible])
{
    switch axis {
    case .horizontal:
        NSLayoutConstraint.activate(
            buildLineLayoutConstraints(axis: axis, options: options, first: view.DSL.left, last: view.DSL.right, items: items)
        )
    case .vertical:
        NSLayoutConstraint.activate(
            buildLineLayoutConstraints(axis: axis, options: options, first: view.DSL.top, last: view.DSL.bottom, items: items)
        )
    }
}

public func activateHorizontalLayout(
    in view: UIView,
    options: [LineLayoutOption] = [],
    items: [LineLayoutItemConvertible])
{
    activateLineLayout(in: view, axis: .horizontal, options: options, items: items)
}

public func activateVerticalLayout(
    in view: UIView,
    options: [LineLayoutOption] = [],
    items: [LineLayoutItemConvertible])
{
    activateLineLayout(in: view, axis: .vertical, options: options, items: items)
}
