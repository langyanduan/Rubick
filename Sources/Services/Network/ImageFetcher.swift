//
//  ImageFetcher.swift
//  Rubick
//
//  Created by WuFan on 16/9/19.
//
//

import Foundation

//private let diskCache: DiskCache

enum ImageFormat {
    case jpeg
    case png
    case gif
    case unknown
}

class ImageFetcher {
    static let shared = ImageFetcher()
    
    var processor: ((UIImage) throws -> UIImage)?
    
    
    
    
    
    
    init() {
    }
}

extension InstanceExtension where Base: UIImageView {
    func setImage(with url: String?, placeholer: UIImage?, fetcher: ImageFetcher = .shared) {
        
    }
}

func test() {
    let v = UIImageView()
    
    v.ext.setImage(with: "", placeholer: nil)
}
