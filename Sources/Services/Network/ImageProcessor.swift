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

struct RoundRadiusProcessor: ImageProcessor {
    func process(_ image: UIImage) -> UIImage? {
        return image
    }
}
