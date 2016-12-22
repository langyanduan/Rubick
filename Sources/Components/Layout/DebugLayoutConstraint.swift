//
//  DebugLayoutConstraint.swift
//  Rubick
//
//  Created by WuFan on 2016/10/25.
//
//

import UIKit

#if DEBUG
class DebugLayoutConstraint: NSLayoutConstraint { }
typealias DSLLayoutConstraint = DebugLayoutConstraint
#else
typealias DSLLayoutConstraint = NSLayoutConstraint
#endif
