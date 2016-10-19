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

protocol LineLayoutOptionValueConvertible {
    func asLineLayoutOptionValue() -> LineLayoutOption.Value
}
extension UIView: LineLayoutOptionValueConvertible {
    func asLineLayoutOptionValue() -> LineLayoutOption.Value {
        return .view(self)
    }
}
extension CGFloat: LineLayoutOptionValueConvertible {
    func asLineLayoutOptionValue() -> LineLayoutOption.Value {
        return .value(self)
    }
}
extension Int: LineLayoutOptionValueConvertible {
    func asLineLayoutOptionValue() -> LineLayoutOption.Value {
        return .value(self.asCGFloat)
    }
}

enum LineLayoutOption {
    enum Attribute {
        case head
        case tail
        case center
    }
    
    enum Value {
        case view(UIView)
        case value(CGFloat)
    }
    
    enum Constant {
        case lessThanOrEqual(Value)
        case greaterThanOrEqual(Value)
        case equal(Value)
        
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
        
        var value: Value {
            switch self {
            case let .lessThanOrEqual(value),
                 let .greaterThanOrEqual(value),
                 let .equal(value):
                return value
            }
        }
    }

    case head(UIView, Attribute)
    case tail(UIView, Attribute)
    case center(UIView, Attribute)
    
    case width(Constant)
    case height(Constant)
    
    static func alignHead(to view: UIView, attribute: Attribute = .head) -> LineLayoutOption {
        return .head(view, attribute)
    }
    static func alignTail(to view: UIView, attribute: Attribute = .tail) -> LineLayoutOption {
        return .tail(view, attribute)
    }
    static func alignCenter(to view: UIView, attribute: Attribute = .center) -> LineLayoutOption {
        return .center(view, attribute)
    }
    
    static func widthLessThanOrEqual(to value: LineLayoutOptionValueConvertible) -> LineLayoutOption {
        return .width(.lessThanOrEqual(value.asLineLayoutOptionValue()))
    }
    static func widthGreaterThanOrEqual(to value: LineLayoutOptionValueConvertible) -> LineLayoutOption {
        return .width(.greaterThanOrEqual(value.asLineLayoutOptionValue()))
    }
    static func widthEqual(to value: LineLayoutOptionValueConvertible) -> LineLayoutOption {
        return .width(.equal(value.asLineLayoutOptionValue()))
    }
    
    static func heightLessThanOrEqual(to value: LineLayoutOptionValueConvertible) -> LineLayoutOption {
        return .height(.lessThanOrEqual(value.asLineLayoutOptionValue()))
    }
    static func heightGreaterThanOrEqual(to value: LineLayoutOptionValueConvertible) -> LineLayoutOption {
        return .height(.greaterThanOrEqual(value.asLineLayoutOptionValue()))
    }
    static func heightEqual(to value: LineLayoutOptionValueConvertible) -> LineLayoutOption {
        return .height(.equal(value.asLineLayoutOptionValue()))
    }
}



@discardableResult
func lineLayout(axis: UILayoutConstraintAxis,
                options: [LineLayoutOption] = [],
                first: ConstraintItem,
                last: ConstraintItem,
                items: [LineLayoutItemConvertible]) -> [NSLayoutConstraint]
{
    var constraints: [NSLayoutConstraint] = []
    var constant: CGFloat?
    var relation: NSLayoutRelation = .equal
    var constraintItem: ConstraintItem = first
    
    func addOptionConstraints(for view: UIView) {
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

        for option in options {
            switch option {
            case let .center(otherView, attribute),
                 let .head(otherView, attribute),
                 let .tail(otherView, attribute):
                let constraint = NSLayoutConstraint(
                    item: view,
                    attribute: firstAttribute(with: axis, option: option),
                    relatedBy: .equal,
                    toItem: otherView,
                    attribute: secondAttribute(with: axis, attribute: attribute),
                    multiplier: 1,
                    constant: 0
                )
                constraints.append(constraint)
            case let .width(constant),
                 let .height(constant):
                
                let attribute = constantAttribute(with: option)
                let constraint: NSLayoutConstraint
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
                constraints.append(constraint)
            }
        }
    }
    
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
                item: constraintItem.view,
                attribute: constraintItem.attribute,
                relatedBy: relation,
                toItem: view,
                attribute: axis == .vertical ? .top : .left,
                multiplier: 1,
                constant: constant ?? 0)
            )
            
            addOptionConstraints(for: view)
            
            constant = nil
            relation = .equal
            constraintItem = ConstraintItem(view: view, attribute: axis == .vertical ? .top : .right)
        }
    }
    
    constraints.append(NSLayoutConstraint(
        item: constraintItem.view,
        attribute: constraintItem.attribute,
        relatedBy: relation,
        toItem: last.view,
        attribute: last.attribute,
        multiplier: 1,
        constant: constant ?? 0)
    )
    
    NSLayoutConstraint.activate(constraints)
    
    return constraints
}

extension NSLayoutConstraint {
    static func activeLineLayout(axis: UILayoutConstraintAxis,
                           options: [LineLayoutOption] = [],
                           first: ConstraintItem,
                           last: ConstraintItem,
                           items: [LineLayoutItemConvertible]) {
        activate(lineLayout(axis: axis, options: options, first: first, last: last, items: items))
    }
}
