//
//  DebugLayoutConstraint.swift
//  Rubick
//
//  Created by WuFan on 2016/10/25.
//
//

import UIKit

class DebugLayoutConstraint: NSLayoutConstraint { }

#if DEBUG
typealias DSLLayoutConstraint = DebugLayoutConstraint
#else
typealias DSLLayoutConstraint = NSLayoutConstraint
#endif
