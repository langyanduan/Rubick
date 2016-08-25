//
//  TypeConvert.swift
//  Rubick
//
//  Created by wufan on 16/8/25.
//
//

import Foundation
import CoreGraphics

extension Int {
    var CGFloat: CoreGraphics.CGFloat {
        return CoreGraphics.CGFloat(self)
    }
}