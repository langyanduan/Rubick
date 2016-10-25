//
//  LayoutConstraint.swift
//  Rubick
//
//  Created by WuFan on 2016/10/25.
//
//

import Foundation
import UIKit

public struct LayoutConstraint {
    let firstItem: UIView
    let firstAttribute: NSLayoutAttribute
    let relation: NSLayoutRelation
    let secondItem: UIView?
    let secondAttribute: NSLayoutAttribute
    let constant: CGFloat
    let multiplier: CGFloat
    var priority: UILayoutPriority
    
    init(item: LayoutItem, layoutCondition: LayoutCondition, relatedBy relation: NSLayoutRelation) {
        self.firstItem = item.view
        self.firstAttribute = item.attribute
        self.relation = relation
        self.secondItem = layoutCondition.view
        self.secondAttribute = layoutCondition.attribute
        self.constant = layoutCondition.constant
        self.multiplier = layoutCondition.multiplier
        self.priority = layoutCondition.priority
    }
}

public struct LayoutConstraintGroup {
    var collection: [LayoutConstraint]
}
