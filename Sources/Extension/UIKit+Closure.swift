//
//  UIControl+Extension.swift
//  Rubick
//
//  Created by WuFan on 2016/10/9.
//
//

import Foundation
import UIKit

private class Target<Control> {
    let handler: (Control) -> Void
    init(handler: @escaping (Control) -> Void) {
        self.handler = handler
    }
    
    @objc
    func eventHandler(object: AnyObject) {
        if let control = object as? Control {
            self.handler(control)
        }
    }
}

private var associatedObjectKey = 0

extension UIControlEvents: Hashable {
    public var hashValue: Int {
        return Int(self.rawValue)
    }
}

extension InstanceExtension where Base: UIControl {
    public func on(controlEvents event: UIControlEvents, handler: @escaping (Base) -> Void) {
        typealias Collection = [UIControlEvents: Target<Base>]
        let target = Target(handler: handler)
        let box: MutableBox<Collection>
        if let object = objc_getAssociatedObject(base, &associatedObjectKey) as? MutableBox<Collection> {
            box = object
        } else {
            box = MutableBox(Collection())
            objc_setAssociatedObject(base, &associatedObjectKey, box, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        box.value[event] = target
        base.addTarget(target, action: #selector(Target<Base>.eventHandler(object:)), for: event)
    }
}

extension InstanceExtension where Base: UITapGestureRecognizer {
    @discardableResult
    public func on(handler: @escaping (UITapGestureRecognizer) -> Void) -> Base {
        let target = Target(handler: handler)
        objc_setAssociatedObject(base, &associatedObjectKey, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        base.addTarget(target, action: #selector(Target<Base>.eventHandler(object:)))
        return base
    }
}

extension UITapGestureRecognizer {
    public convenience init(handler: @escaping (UITapGestureRecognizer) -> Void) {
        self.init()
        self.ext.on(handler: handler)
    }
}

extension InstanceExtension where Base: UIBarButtonItem {
    @discardableResult
    public func on(handler: @escaping (Base) -> Void) -> Base {
        let target = Target(handler: handler)
        objc_setAssociatedObject(base, &associatedObjectKey, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        base.target = target
        base.action = #selector(Target<Base>.eventHandler(object:))
        return base
    }
}

extension UIBarButtonItem {
    public convenience init(image: UIImage?, style: UIBarButtonItemStyle, handler: @escaping (UIBarButtonItem) -> Void) {
        self.init(image: image, style: style, target: nil, action: nil)
        self.ext.on(handler: handler)
    }
    public convenience init(title: String?, style: UIBarButtonItemStyle, handler: @escaping (UIBarButtonItem) -> Void) {
        self.init(title: title, style: style, target: nil, action: nil)
        self.ext.on(handler: handler)
    }
}
