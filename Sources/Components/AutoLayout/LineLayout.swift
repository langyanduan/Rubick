//
//  LineLayout.swift
//  Rubick
//
//  Created by WuFan on 2016/10/19.
//
//

import Foundation
import UIKit

public enum LineLayoutItem {
    case lessThanOrEqual(CGFloatConvertible)
    case greaterThanOrEqual(CGFloatConvertible)
    case equal(CGFloatConvertible)
    case view(UIView)
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

prefix operator <=
public prefix func <=(value: CGFloatConvertible) -> LineLayoutItem {
    return .lessThanOrEqual(value)
}
prefix operator >=
public prefix func >=(value: CGFloatConvertible) -> LineLayoutItem {
    return .greaterThanOrEqual(value)
}
prefix operator ==
public prefix func ==(value: CGFloatConvertible) -> LineLayoutItem {
    return .equal(value)
}

// line layout option
public enum LineLayoutOption {
    case head(UIView, Attribute)
    case tail(UIView, Attribute)
    case center(UIView, Attribute)
    
    case width(Constant)
    case height(Constant)
}

extension LineLayoutOption {
    public enum Attribute {
        case head
        case tail
        case center
    }
    
    public enum Value {
        case view(UIView)
        case value(CGFloat)
    }
    
    public enum Constant {
        case lessThanOrEqual(Value)
        case greaterThanOrEqual(Value)
        case equal(Value)
    }
}

extension LineLayoutOption.Constant {
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
    
    var value: LineLayoutOption.Value {
        switch self {
        case let .lessThanOrEqual(value),
             let .greaterThanOrEqual(value),
             let .equal(value):
            return value
        }
    }
}

public protocol LineLayoutOptionValueConvertible {
    func asLineLayoutOptionValue() -> LineLayoutOption.Value
}
extension UIView: LineLayoutOptionValueConvertible {
    public func asLineLayoutOptionValue() -> LineLayoutOption.Value {
        return .view(self)
    }
}
extension CGFloat: LineLayoutOptionValueConvertible {
    public func asLineLayoutOptionValue() -> LineLayoutOption.Value {
        return .value(self)
    }
}
extension Int: LineLayoutOptionValueConvertible {
    public func asLineLayoutOptionValue() -> LineLayoutOption.Value {
        return .value(self.asCGFloat)
    }
}

extension LineLayoutOption {
    public static func alignHead(to view: UIView, attribute: Attribute = .head) -> LineLayoutOption {
        return .head(view, attribute)
    }
    public static func alignTail(to view: UIView, attribute: Attribute = .tail) -> LineLayoutOption {
        return .tail(view, attribute)
    }
    public static func alignCenter(to view: UIView, attribute: Attribute = .center) -> LineLayoutOption {
        return .center(view, attribute)
    }
    
    public static func widthLessThanOrEqual(to value: LineLayoutOptionValueConvertible) -> LineLayoutOption {
        return .width(.lessThanOrEqual(value.asLineLayoutOptionValue()))
    }
    public static func widthGreaterThanOrEqual(to value: LineLayoutOptionValueConvertible) -> LineLayoutOption {
        return .width(.greaterThanOrEqual(value.asLineLayoutOptionValue()))
    }
    public static func widthEqual(to value: LineLayoutOptionValueConvertible) -> LineLayoutOption {
        return .width(.equal(value.asLineLayoutOptionValue()))
    }
    
    public static func heightLessThanOrEqual(to value: LineLayoutOptionValueConvertible) -> LineLayoutOption {
        return .height(.lessThanOrEqual(value.asLineLayoutOptionValue()))
    }
    public static func heightGreaterThanOrEqual(to value: LineLayoutOptionValueConvertible) -> LineLayoutOption {
        return .height(.greaterThanOrEqual(value.asLineLayoutOptionValue()))
    }
    public static func heightEqual(to value: LineLayoutOptionValueConvertible) -> LineLayoutOption {
        return .height(.equal(value.asLineLayoutOptionValue()))
    }
}

// build constraints
private func buildConstraints(for view: UIView, axis: UILayoutConstraintAxis, options: [LineLayoutOption]) -> [NSLayoutConstraint] {
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
            constraint = NSLayoutConstraint(
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
                constraint = NSLayoutConstraint(
                    item: view,
                    attribute: attribute,
                    relatedBy: constant.relation,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1,
                    constant: value
                )
            case let .view(view):
                constraint = NSLayoutConstraint(
                    item: view,
                    attribute: attribute,
                    relatedBy: constant.relation,
                    toItem: view,
                    attribute: attribute,
                    multiplier: 1,
                    constant: 0
                )
            }
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
            constraints.append(NSLayoutConstraint(
                item: view,
                attribute: axis == .vertical ? .top : .left,
                relatedBy: relation,
                toItem: prevLayoutItem.view,
                attribute: prevLayoutItem.attribute,
                multiplier: 1,
                constant: constant ?? 0)
            )
            constraints += buildConstraints(for: view, axis: axis, options: options)
            
            constant = nil
            relation = .equal
            prevLayoutItem = LayoutItem(view: view, attribute: axis == .vertical ? .top : .right)
        }
    }
    
    constraints.append(NSLayoutConstraint(
        item: last.view,
        attribute: last.attribute,
        relatedBy: relation,
        toItem: prevLayoutItem.view,
        attribute: prevLayoutItem.attribute,
        multiplier: 1,
        constant: constant ?? 0)
    )
    
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
    NSLayoutConstraint.activate(buildLineLayoutConstraints(axis: axis, options: options, first: first, last: last, items: items))
}

public func activateLineLayout(
    in view: UIView,
    axis: UILayoutConstraintAxis,
    options: [LineLayoutOption] = [],
    items: [LineLayoutItemConvertible])
{
    switch axis {
    case .horizontal:
        NSLayoutConstraint.activate(buildLineLayoutConstraints(axis: axis, options: options, first: view.left, last: view.right, items: items))
    case .vertical:
        NSLayoutConstraint.activate(buildLineLayoutConstraints(axis: axis, options: options, first: view.top, last: view.bottom, items: items))
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
