//
//  UIColor+Extension.swift
//  Rubick
//
//  Created by wufan on 16/8/18.
//
//

import UIKit

public func UIColorFromRGB(_ rgbHex: UInt32) -> UIColor {
    let r = CGFloat((rgbHex & 0x00ff0000) >> 16)
    let g = CGFloat((rgbHex & 0x0000ff00) >> 8)
    let b = CGFloat((rgbHex & 0x000000ff) >> 0)
    return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
}

public func ColorGetComponents(_ color: UIColor) -> [CGFloat] {
    if color == UIColor.black {
        return [ 0, 0, 0, 1 ]
    } else if color == UIColor.darkGray {
        return [ 0.333, 0.333, 0.333, 1 ]
    } else if color == UIColor.lightGray {
        return [ 0.667, 0.667, 0.667, 1 ]
    } else if color == UIColor.white {
        return [ 1, 1, 1, 1 ]
    } else if color == UIColor.gray {
        return [ 0.5, 0.5, 0.5, 1 ]
    }
    
    let components = color.cgColor.components
    return [ components![0], components![1], components![2], components![3] ]
}

extension UIColor {
    public var rbk_red: CGFloat {
        get {
            return ColorGetComponents(self)[0]
        }
    }
    public var rbk_green: CGFloat {
        get {
            return ColorGetComponents(self)[1]
        }
    }
    public var rbk_blue: CGFloat {
        get {
            return ColorGetComponents(self)[2]
        }
    }
    public var rbk_alpha: CGFloat {
        get {
            return ColorGetComponents(self)[3]
        }
    }
    
    public static func rbk_random() -> UIColor {
        return UIColorFromRGB(arc4random_uniform(0xffffff))
    }
    
    public func rbk_colorWithAlpah(_ alpha: CGFloat) -> UIColor {
        let components = ColorGetComponents(self)
        let r = components[0]
        let g = components[1]
        let b = components[2]
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}
