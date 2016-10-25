//
//  ViewLayoutDSL.swift
//  Rubick
//
//  Created by WuFan on 2016/10/25.
//
//

import Foundation
import UIKit

public struct ViewDSL {
    let base: UIView
    
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
    public var size: LayoutSizeItem { return LayoutSizeItem(view: base) }
    
    public func insets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> LayoutEdgesItem {
        return LayoutEdgesItem(view: base, insets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
}

extension UIView {
    public var dsl: ViewDSL {
        return ViewDSL(base: self)
    }
}

public protocol ViewDSLConvertible {
    func asViewLayoutDSL() -> ViewDSL
}

extension UIView: ViewDSLConvertible {
    public func asViewLayoutDSL() -> ViewDSL {
        return self.dsl
    }
}

extension ViewDSL: ViewDSLConvertible {
    public func asViewLayoutDSL() -> ViewDSL {
        return self
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
