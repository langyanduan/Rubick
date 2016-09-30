//
//  ImageCache.swift
//  Rubick
//
//  Created by WuFan on 2016/9/23.
//
//

import Foundation
import UIKit

extension URL {
    fileprivate var imageCacheKey: String {
        return self.absoluteString
    }
}

public class ImageCache {
    private static let defaultDiskCachePath = "images"
    private static let defaultDiskCache = DiskCache<UIImage>(path: defaultDiskCachePath, serializer: UIImageCacheSerializer.shared)
    
    private let diskCache: DiskCache<UIImage>
    private let memoryCache: MemoryCache<UIImage>
//    
    init(diskCache: DiskCache<UIImage> = defaultDiskCache) {
        self.diskCache = diskCache
        self.memoryCache = MemoryCache()
    }
    
    init(diskCachePath: String) {
        self.diskCache = DiskCache(path: diskCachePath, serializer: UIImageCacheSerializer.shared)
        self.memoryCache = MemoryCache()
    }
    
    func diskImage(withURL url: URL) -> UIImage? {
        return diskCache.object(forKey: url.absoluteString)
    }
    
    func setDiskImage(_ image: UIImage, forURL url: URL) {
        diskCache.setObject(image, forKey: url.absoluteString)
    }
    
    func memoryImage(withURL url: URL) -> UIImage? {
        return memoryCache.object(forKey: url.absoluteString)
    }
    
    func setMemoryImage(_ image: UIImage, forURL url: URL) {
        memoryCache.setObject(image, forKey: url.absoluteString)
    }
}

public class UIImageCacheSerializer: CacheSerializer<UIImage> {
    public static let shared = UIImageCacheSerializer()
    
    private override init() {}
    
    public override func data(forObject image: UIImage) throws -> Data {
        guard let data = UIImagePNGRepresentation(image) else {
            throw CommonError.serializer
        }
        return data
    }

    public override func object(forData data: Data) throws -> UIImage {
        guard let image = ImageDecoder.image(fromData: data, scale: UIScreen.main.scale) else {
            throw CommonError.serializer
        }
        return image
    }
}
