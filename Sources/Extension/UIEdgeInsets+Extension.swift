//
//  UIEdgeInsets+Extension.swift
//  Rubick
//
//  Created by wufan on 16/8/29.
//
//

import Foundation
import UIKit

extension UIEdgeInsets {
    public init(x: CGFloat, y: CGFloat) {
        self.init(top: y, left: x, bottom: y, right: x)
    }
    
    public init(value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
}
