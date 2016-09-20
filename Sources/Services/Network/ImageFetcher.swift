//
//  ImageFetcher.swift
//  Rubick
//
//  Created by WuFan on 16/9/19.
//
//

import Foundation

private let ImageDiskCachePath = "images"
private let diskCache: DiskCache = DiskCache(path: ImageDiskCachePath)

enum ImageFormat {
    case jpeg
    case png
    case gif
    case unknown
}

class Resource {
    
}

extension Resource: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        return URLRequest(url: URL(fileURLWithPath: ""))
    }
}

class ImageFetcher {
    private let memoryCache = MemoryCache()
    private let manager = Manager()
    private let queue = DispatchQueue(label: "imageFetcher", attributes: .concurrent)
    
    public static let shared = ImageFetcher()
    
    public var processor: ((UIImage) -> UIImage?)?
    public var decodeAsync: Bool = false
    
    init() { }
    deinit { }
    
    func download(with resource: Resource) -> Request {
        let urlRequest = try! resource.asURLRequest()
        
        let request = manager.sendRequest(urlRequest).response(queue) { (data, response, error) in
            if let data = data {
                let image = ImageSerializer.imageFromData(data)
                
                let finalImage: UIImage?
                if let image = image, let processor = self.processor {
                    finalImage = processor(image)
                } else {
                    finalImage = image
                }
                
                
            }
        }
        
        return request
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
