//
//  LayoutCondition.swift
//  Rubick
//
//  Created by WuFan on 2016/10/25.
//
//

import Foundation
import UIKit

public struct LayoutCondition {
    let view: UIView?
    let attribute: NSLayoutAttribute
    var constant: CGFloat
    var multiplier: CGFloat = 1
    var priority: UILayoutPriority = UILayoutPriorityRequired
    
    init(view: UIView?, attribute: NSLayoutAttribute, constant: CGFloat = 0) {
        self.view = view
        self.attribute = attribute
        self.constant = constant
    }
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
