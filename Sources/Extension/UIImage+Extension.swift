//
//  UIImage+Extension.swift
//  Rubick
//
//  Created by wufan on 16/8/25.
//
//

import UIKit

extension UIImage {
    static public func rbk_image(with color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(ctx, color.CGColor)
        CGContextFillRect(ctx, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
