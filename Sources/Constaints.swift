//
//  Constaints.swift
//  Rubick
//
//  Created by wufan on 16/8/19.
//
//

import Foundation

public func CGFloatFromPixel(pixel: Int) -> CGFloat {
    struct Static {
        static let unit: CGFloat = 1 / UIScreen.mainScreen().scale
    }
    return Static.unit * CGFloat(pixel)
}

public let ScreenWidth = UIScreen.mainScreen().bounds.width
public let ScreenHeight = UIScreen.mainScreen().bounds.height