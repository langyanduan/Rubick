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

//字符串转为颜色  sxf todo
public func UIColorFromHexString(_ hexString: NSString) -> UIColor {
     var cString:NSString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased() as NSString
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substring(from: 1) as NSString
    }
    if (cString.length != 6) {
        return UIColor.gray
    }
    
    var rString = (cString as NSString).substring(to: 2)
    var gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
    var bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

public func UIColorGetComponents(_ color: UIColor) -> [CGFloat] {
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

extension InstanceExtension where Base: UIColor {
    
    public var redComponent: CGFloat {
        return UIColorGetComponents(base)[0]
        
    }
    public var greenComponent: CGFloat {
        return UIColorGetComponents(base)[1]
        
    }
    public var blueComponent: CGFloat {
        return UIColorGetComponents(base)[2]
        
    }
    public var alphaComponent: CGFloat {
        return UIColorGetComponents(base)[3]
    }
}

extension TypeExtension where Base: UIColor {
    public var random: UIColor {
        return UIColorFromRGB(arc4random_uniform(0xffffff))
    }
}

