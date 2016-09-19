//
//  ImageFetcher.swift
//  Rubick
//
//  Created by WuFan on 16/9/19.
//
//

import Foundation

enum ImageFormat {
    case jpeg
    case png
    case gif
    case unknown
}

class ImageFetcher {
    static let shared = ImageFetcher()
}

extension InstanceExtension where Base: UIImageView {
    func setImage(with url: String?, placeholer: UIImage?, fetcher: ImageFetcher = .shared) {
        
    }
}

func test() {
    let v = UIImageView()
    
    v.ext.setImage(with: "", placeholer: nil)
}
