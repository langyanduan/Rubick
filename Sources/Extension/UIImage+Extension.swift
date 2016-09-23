//
//  UIImage+Extension.swift
//  Rubick
//
//  Created by wufan on 16/8/25.
//
//

import UIKit

extension UIImage {
    public convenience init?(color: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else {
            return nil
        }
        
        self.init(cgImage: cgImage)
    }
}

enum ImageResizeMode {
//    case top
//    case bottom
//    case left
//    case right
//    case center
    case scaleToFill
    case scaleAspectFit
    case scaleAspectFill
}

extension InstanceExtension where Base: UIImage {
    public func stretchableImage() -> UIImage {
        let width = base.size.width
        let height = base.size.height
        let vInset = floor(height / 2)
        let hInset = floor(width / 2)
        return base.resizableImage(withCapInsets: UIEdgeInsets(top: vInset, left: hInset, bottom: height - vInset - 1, right: width - hInset - 1), resizingMode: .tile)
    }
    
    func roundCornerImage(withRadius radius: CGFloat) -> UIImage {
        return base
    }
    func circularImage(withRadius radius: CGFloat) -> UIImage {
        return base
    }
    func image(withTintColor tintColor: UIColor) -> UIImage {
        return base
    }
    
    func resizeImage(withSize size: CGSize, mode: ImageResizeMode) -> UIImage {
        return base
    }
}


