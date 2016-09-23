//
//  ImageCache.swift
//  Rubick
//
//  Created by WuFan on 2016/9/23.
//
//

import Foundation
import UIKit

class ImageCache {
    let diskCache: DiskCache<UIImage>
    let memoryCache: MemoryCache<UIImage>
    
    init() {
        diskCache = DiskCache()
        memoryCache = MemoryCache()
    }
}
