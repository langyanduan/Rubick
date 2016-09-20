//
//  Constaints.swift
//  Rubick
//
//  Created by wufan on 16/8/19.
//
//

import Foundation

private struct Static {
    static let unit: CGFloat = 1 / UIScreen.main.scale
}

public func CGFloatFromPixel(_ pixel: Int) -> CGFloat {
    return Static.unit * CGFloat(pixel)
}

public func CGFloatFromScalePixel(_ pixel: CGFloat) -> CGFloat {
    return Static.unit * floor(pixel * UIScreen.main.scale)
}

public let ScreenWidth = UIScreen.main.bounds.width
public let ScreenHeight = UIScreen.main.bounds.height


public func assertMainThread() {
    assert(Thread.isMainThread)
}

extension UIViewAnimationOptions {
    public init(curve: UIViewAnimationCurve) {
        switch curve {
        case .easeIn:
            self = [.curveEaseIn]
        case .easeInOut:
            self = [.curveEaseInOut]
        case .easeOut:
            self = [.curveEaseOut]
        case .linear:
            self = [.curveLinear]
        }
    }
}
