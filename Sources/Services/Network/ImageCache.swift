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
    private static let defaultDiskCachePath = "images"
    private static let defaultDiskCache = DiskCache<UIImage>(path: defaultDiskCachePath)
    
    let diskCache: DiskCache<UIImage>
    let memoryCache: MemoryCache<UIImage>
    
    init(diskCache: DiskCache<UIImage> = defaultDiskCache) {
        self.diskCache = diskCache
        self.memoryCache = MemoryCache()
    }
    
    init(diskCachePath: String) {
        self.diskCache = DiskCache(path: diskCachePath)
        self.memoryCache = MemoryCache()
    }
    
//    func image(withURL url: URL) -> UIImage? {
//        if let image = memoryImage(withURL: url) {
//            return image
//        }
//        if let image = diskImage(withURL: url) {
//            return image
//        }
//        return nil
//    }
    
    func diskImage(withURL url: URL) -> UIImage? {
        
        return nil
    }
    
    func setDiskImage(_ image: UIImage, forURL url: URL) {
        
    }
    
    func memoryImage(withURL url: URL) -> UIImage? {
        return nil
    }
    
    func setMemoryImage(_ image: UIImage, forURL url: URL) {
        
    }
}
