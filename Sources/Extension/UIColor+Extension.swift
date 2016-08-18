//
//  UIColor+Extension.swift
//  Wings
//
//  Created by wufan on 16/8/18.
//
//

import UIKit

public func UIColorFromRGB(rgbHex: UInt32) -> UIColor {
    let r = CGFloat((rgbHex & 0x00ff0000) >> 16)
    let g = CGFloat((rgbHex & 0x0000ff00) >> 8)
    let b = CGFloat((rgbHex & 0x000000ff) >> 0)
    return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
}

extension UIColor {
    public var rbk_red: UInt8 {
        get {
            return 0
        }
    }
    public var rbk_green: UInt8 {
        get {
            return 0
        }
    }
    public var rbk_blue: UInt8 {
        get {
            return 0
        }
    }
}
