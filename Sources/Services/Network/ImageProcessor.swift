//
//  ImageProcessor.swift
//  Rubick
//
//  Created by WuFan on 2016/9/23.
//
//

import Foundation

public protocol ImageProcessor {
    func process(_ image: UIImage) -> UIImage?
}

public struct RoundCornerImageProcessor: ImageProcessor {
    let radius: CGFloat
    
    public init(radius: CGFloat) {
        self.radius = radius
    }
    
    public func process(_ image: UIImage) -> UIImage? {
        return image.ext.roundCornerImage(withRadius: radius)
    }
}

public struct CircularImageProcessor: ImageProcessor {
    let radius: CGFloat
    
    public init(radius: CGFloat) {
        self.radius = radius
    }
    
    public func process(_ image: UIImage) -> UIImage? {
        return image.ext.circularImage(withRadius: radius)
    }
}

public struct ResizingImageProcessor: ImageProcessor {
    let size: CGSize
    let mode: ImageResizeMode
    
    public init(size: CGSize, mode: ImageResizeMode) {
        self.size = size
        self.mode = mode
    }
    
    public func process(_ image: UIImage) -> UIImage? {
        return image.ext.resizeImage(withSize: size, mode: mode)
    }
}

public struct TintColorImageProcessor: ImageProcessor {
    let tintColor: UIColor
    
    public init(tintColor: UIColor) {
        self.tintColor = tintColor
    }
    
    public func process(_ image: UIImage) -> UIImage? {
        return image.ext.image(withTintColor: tintColor)
    }
}
