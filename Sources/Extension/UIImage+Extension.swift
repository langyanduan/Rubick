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
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        defer { UIGraphicsEndImageContext() }
        
        let rect = CGRect(origin: .zero, size: base.size)
        
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        base.draw(in: rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    public func circularImage(withRadius radius: CGFloat) -> UIImage {
        let length = radius * 2
        let width = base.size.width, height = base.size.height
        let aspectRatio = height == 0.0 ? 1.0 : width / height
        let rect: CGRect
        if width > height {
            let aspectWidth = round(aspectRatio * length)
            rect = CGRect(
                x: radius - aspectWidth / 2,
                y: 0,
                width: aspectWidth,
                height: length)
        } else {
            let aspectHeight = round(length / aspectRatio)
            rect = CGRect(
                x: 0,
                y: radius - aspectHeight / 2,
                width: length,
                height: aspectHeight)
        }
        let size = CGSize(width: length, height: length)
        UIGraphicsBeginImageContextWithOptions(size, false, base.scale)
        defer { UIGraphicsEndImageContext() }
        UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: radius).addClip()
        base.draw(in: rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    public func resizeImage(withSize size: CGSize, mode: ImageResizeMode = .scaleToFill) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, base.scale)
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

private func forceDecode(forImage image: UIImage) -> UIImage? {
    guard let cgImage = image.cgImage else { return nil }
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
    
    let scale = image.scale
    let orientation = image.imageOrientation
    
    context.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: cgImage.width, height: cgImage.height)))
    guard let decodedImageRef = context.makeImage() else { return nil }
    return UIImage(cgImage: decodedImageRef, scale: scale, orientation: orientation)
}

extension InstanceExtension where Base: UIImage {
    public func decoded() -> UIImage? {
        return forceDecode(forImage: base)
    }
}

extension TypeExtension where Base: UIImage {
    public func decode(fromData data: Data, scale: CGFloat) -> UIImage? {
        guard let image = UIImage(data: data, scale: scale) else {
            return nil
        }
        
        return forceDecode(forImage: image)
    }
    
    public func decode(fromContentFile fileName: String) -> UIImage? {
        guard let image = UIImage(contentsOfFile: fileName) else {
            return nil
        }
        return forceDecode(forImage: image)
    }
}

