//
//  LineLayoutOption.swift
//  Rubick
//
//  Created by WuFan on 2016/10/25.
//
//

import Foundation
import UIKit

// line layout option
public enum LineLayoutOption {
    case head(UIView, Attribute)
    case tail(UIView, Attribute)
    case center(UIView, Attribute)
    
    case width(LayoutValueRelation)
    case height(LayoutValueRelation)
    
    case equalWidth
    case equalHeight
}

extension LineLayoutOption {
    public enum Attribute {
        case head
        case tail
        case center
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
