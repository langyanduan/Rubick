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

public enum ImageResizeMode {
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
    
    public func image(withTintColor tintColor: UIColor) -> UIImage {
        return base
    }
    public func roundCornerImage(withRadius radius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(base.size)
        defer { UIGraphicsEndImageContext() }
        
        let rect = CGRect(origin: .zero, size: base.size)
        
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        base.draw(in: rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    public func circularImage(withRadius radius: CGFloat) -> UIImage {
        let size = CGSize(width: 2 * radius, height: 2 * radius)
        
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        
        UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: radius).addClip()
        
        let x = radius - base.size.width / 2, y = radius - base.size.height / 2
        let rect = CGRect(origin: CGPoint(x: x, y: y), size: base.size)
        base.draw(in: rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    public func resizeImage(withSize size: CGSize, mode: ImageResizeMode = .scaleToFill) -> UIImage {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        
        let rect: CGRect
        switch mode {
        case .scaleToFill:
            rect = CGRect(origin: .zero, size: size)
        case .scaleAspectFill:
            let aspectRatio = base.size.height == 0.0 ? 1.0 : base.size.width / base.size.height
            let aspectWidth = round(aspectRatio * size.height)
            let aspectHeight = round(size.width / aspectRatio)
            
            let width: CGFloat, height: CGFloat
            if aspectWidth < size.width {
                width = size.width
                height = aspectHeight
            } else {
                width = aspectWidth
                height = size.height
            }
            
            rect = CGRect(x: (size.width - width) / 2, y: (size.height - height) / 2, width: width, height: height)
        case .scaleAspectFit:
            let aspectRatio = base.size.height == 0.0 ? 1.0 : base.size.width / base.size.height
            let aspectWidth = round(aspectRatio * size.height)
            let aspectHeight = round(size.width / aspectRatio)
            
            let width: CGFloat, height: CGFloat
            if aspectWidth > size.width {
                width = size.width
                height = aspectHeight
            } else {
                width = aspectWidth
                height = size.height
            }
            
            rect = CGRect(x: (size.width - width) / 2, y: (size.height - height) / 2, width: width, height: height)
        }
        
        base.draw(in: rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

extension TypeExtension where Base: UIImage {
    private func decode(cgImage: CGImage, scale: CGFloat, orientation: UIImageOrientation) -> UIImage? {
        guard let context = CGContext(
            data: nil,
            width: cgImage.width,
            height: cgImage.height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: cgImage.bitmapInfo.rawValue) else {
            return nil
        }
        
        context.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: cgImage.width, height: cgImage.height)))
        guard let decodedImageRef = context.makeImage() else { return nil }
        return UIImage(cgImage: decodedImageRef, scale: scale, orientation: orientation)
    }
    
    public func decode(fromData data: Data, scale: CGFloat) -> UIImage? {
        guard let image = UIImage(data: data, scale: scale), let cgImage = image.cgImage else {
            return nil
        }
        
        return decode(cgImage: cgImage, scale: scale, orientation: image.imageOrientation)
    }
    
    public func decode(fromContentFile fileName: String) -> UIImage? {
        guard let image = UIImage(contentsOfFile: fileName), let cgImage = image.cgImage else {
            return nil
        }
        return decode(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}

