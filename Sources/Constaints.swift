//
//  Constaints.swift
//  Rubick
//
//  Created by wufan on 16/8/19.
//
//

import Foundation

private struct Static {
    static let unit: CGFloat = 1 / UIScreen.mainScreen().scale
}

public func CGFloatFromPixel(pixel: Int) -> CGFloat {
    return Static.unit * CGFloat(pixel)
}

public func CGFloatFromScalePixel(pixel: CGFloat) -> CGFloat {
    return Static.unit * floor(pixel * UIScreen.mainScreen().scale)
}

public let ScreenWidth = UIScreen.mainScreen().bounds.width
public let ScreenHeight = UIScreen.mainScreen().bounds.height