//
//  UIColor+Extension.swift
//  Rubick
//
//  Created by wufan on 16/8/18.
//
//

import UIKit

public func UIColorFromRGB(_ rgb: UInt32) -> UIColor {
    let r = CGFloat((rgb & 0x00ff0000) >> 16)
    let g = CGFloat((rgb & 0x0000ff00) >> 8)
    let b = CGFloat((rgb & 0x000000ff) >> 0)
    return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
}

/**
 字符串转为颜色
 
 - parameter string: 颜色的16进制表示, 如黑色: "2b2b2b" 或 "#2b2b2b"
 
 - returns: UIColor
 */
public func UIColorFromRGB(_ string: String) -> UIColor {
    var rgb = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).trimmingCharacters(in: CharacterSet(charactersIn: "#"))
    guard rgb.characters.count == 6 else {
        return .black
    }
    
    func substring(startOffset: Int, endOffset: Int) -> String {
        let lower = rgb.characters.index(rgb.characters.startIndex, offsetBy: startOffset)
        let upper = rgb.characters.index(rgb.characters.startIndex, offsetBy: endOffset)
        return rgb.substring(with: Range(uncheckedBounds: (lower: lower, upper: upper)))
    }
    
    let rString = substring(startOffset: 0, endOffset: 2)
    let gString = substring(startOffset: 2, endOffset: 4)
    let bString = substring(startOffset: 4, endOffset: 6)
    
    var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
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

