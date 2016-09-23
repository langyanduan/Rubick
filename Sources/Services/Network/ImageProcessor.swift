//
//  ImageProcessor.swift
//  Rubick
//
//  Created by WuFan on 2016/9/23.
//
//

import Foundation

protocol ImageProcessor {
    func process(_ image: UIImage) -> UIImage?
}

struct RoundCornerImageProcessor: ImageProcessor {
    let radius: CGFloat
    
    func process(_ image: UIImage) -> UIImage? {
        return image.ext.roundCornerImage(withRadius: radius)
    }
}

struct CircularImageProcessor: ImageProcessor {
    let radius: CGFloat
    
    func process(_ image: UIImage) -> UIImage? {
        return image.ext.circularImage(withRadius: radius)
    }
}

struct ResizingImageProcessor: ImageProcessor {
    let size: CGSize
    let mode: ImageResizeMode
    
    func process(_ image: UIImage) -> UIImage? {
        return image.ext.resizeImage(withSize: size, mode: mode)
    }
}
