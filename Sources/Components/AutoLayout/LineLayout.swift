//
//  LineLayout.swift
//  Rubick
//
//  Created by WuFan on 2016/10/19.
//
//

import Foundation
import UIKit

public enum LayoutValue {
    case view(UIView)
    case value(CGFloat)
}

public enum LayoutConstant {
    case lessThanOrEqual(LayoutValue)
    case greaterThanOrEqual(LayoutValue)
    case equal(LayoutValue)
}

public enum LineLayoutItem {
    case lessThanOrEqual(CGFloatConvertible)
    case greaterThanOrEqual(CGFloatConvertible)
    case equal(CGFloatConvertible)
    case view(UIView)
    case viewConstant(UIView, LayoutConstant)
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

public protocol LayoutValueConvertible {
    func asLayoutValue() -> LayoutValue
}
extension UIView: LayoutValueConvertible {
    public func asLayoutValue() -> LayoutValue {
        return .view(self)
    }
}
extension CGFloat: LayoutValueConvertible {
    public func asLayoutValue() -> LayoutValue {
        return .value(self)
    }
}
extension Int: LayoutValueConvertible {
    public func asLayoutValue() -> LayoutValue {
        return .value(self.asCGFloat)
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

//infix operator =~: ComparisonPrecedence
public func ==(view: UIView, value: LayoutValueConvertible) -> LineLayoutItem {
    return .viewConstant(view, .equal(value.asLayoutValue()))
}
public func >=(view: UIView, value: LayoutValueConvertible) -> LineLayoutItem {
    return .viewConstant(view, .greaterThanOrEqual(value.asLayoutValue()))
}
public func <=(view: UIView, value: LayoutValueConvertible) -> LineLayoutItem {
    return .viewConstant(view, .lessThanOrEqual(value.asLayoutValue()))
}

// line layout option
public enum LineLayoutOption {
    case head(UIView, Attribute)
    case tail(UIView, Attribute)
    case center(UIView, Attribute)
    
    case width(LayoutConstant)
    case height(LayoutConstant)
}

extension LineLayoutOption {
    public enum Attribute {
        case head
        case tail
        case center
    }
}

extension LayoutConstant {
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
    
    var value: LayoutValue {
        switch self {
        case let .lessThanOrEqual(value),
             let .greaterThanOrEqual(value),
             let .equal(value):
            return value
        }
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
    
    public static func widthLessThanOrEqual(to value: LayoutValueConvertible) -> LineLayoutOption {
        return .width(.lessThanOrEqual(value.asLayoutValue()))
    }
    public static func widthGreaterThanOrEqual(to value: LayoutValueConvertible) -> LineLayoutOption {
        return .width(.greaterThanOrEqual(value.asLayoutValue()))
    }
    public static func widthEqual(to value: LayoutValueConvertible) -> LineLayoutOption {
        return .width(.equal(value.asLayoutValue()))
    }
    
    public static func heightLessThanOrEqual(to value: LayoutValueConvertible) -> LineLayoutOption {
        return .height(.lessThanOrEqual(value.asLayoutValue()))
    }
    public static func heightGreaterThanOrEqual(to value: LayoutValueConvertible) -> LineLayoutOption {
        return .height(.greaterThanOrEqual(value.asLayoutValue()))
    }
    public static func heightEqual(to value: LayoutValueConvertible) -> LineLayoutOption {
        return .height(.equal(value.asLayoutValue()))
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
            case let .view(otherView):
                constraint = NSLayoutConstraint(
                    item: view,
                    attribute: attribute,
                    relatedBy: constant.relation,
                    toItem: otherView,
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
    assert( { () -> Bool in
        func isHorizontal(attribute: NSLayoutAttribute) -> Bool {
            switch attribute {
            case .left, .right, .centerX:
                return true
            default:
                return false
            }
        }
        
        func isVertical(attribute: NSLayoutAttribute) -> Bool {
            switch attribute {
            case .top, .bottom, .centerY:
                return true
            default:
                return false
            }
        }
        
        switch axis {
        case .horizontal:
            return isHorizontal(attribute: first.attribute) && isHorizontal(attribute: last.attribute)
        case .vertical:
            return isVertical(attribute: first.attribute) && isVertical(attribute: last.attribute)
        }
    }())
    
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
            
            view.translatesAutoresizingMaskIntoConstraints = false
            constant = nil
            relation = .equal
            prevLayoutItem = LayoutItem(view: view, attribute: axis == .vertical ? .bottom : .right)
        case let .viewConstant(view, layoutConstant):
            constraints.append(NSLayoutConstraint(
                item: view,
                attribute: axis == .vertical ? .top : .left,
                relatedBy: relation,
                toItem: prevLayoutItem.view,
                attribute: prevLayoutItem.attribute,
                multiplier: 1,
                constant: constant ?? 0)
            )
            
            let attribute: NSLayoutAttribute = axis == .vertical ? .height : .width
            switch layoutConstant.value {
            case .value(let value):
                constraints.append(NSLayoutConstraint(
                    item: view,
                    attribute: attribute,
                    relatedBy: layoutConstant.relation,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1,
                    constant: value)
                )
            case .view(let otherView):
                constraints.append(NSLayoutConstraint(
                    item: view,
                    attribute: attribute,
                    relatedBy: layoutConstant.relation,
                    toItem: otherView,
                    attribute: attribute,
                    multiplier: 1,
                    constant: 0)
                )
            }
            
            constraints += buildConstraints(for: view, axis: axis, options: options)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            constant = nil
            relation = .equal
            prevLayoutItem = LayoutItem(view: view, attribute: axis == .vertical ? .bottom : .right)
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
