//
//  ImageFetcher.swift
//  Rubick
//
//  Created by WuFan on 16/9/19.
//
//

import Foundation

private let ImageDiskCachePath = "images"
//private let diskCache: DiskCache = DiskCache(path: ImageDiskCachePath)

enum ImageFormat {
    case jpeg
    case png
    case gif
    case unknown
}

extension URL {
    fileprivate var imageCacheKey: String {
        return self.absoluteString
    }
}

public struct ImageDownloader {
    public class Cancelable {
//        fileprivate private(set) var completeHandler: ((Void) -> Void)?
        fileprivate private(set) var request: Request?
        fileprivate private(set) var downloadCanceled: Bool = false
        fileprivate private(set) var handleCanceled: Bool = false
        
        public func cancelDownload() {
            guard !downloadCanceled else {
                return
            }
            downloadCanceled = true
            request?.cancel()
        }
        public func cancelHandle() {
            guard !handleCanceled else {
                return
            }
            handleCanceled = true
//            completeHandler = nil
        }
        
        public func cancelAll() {
            cancelDownload()
            cancelHandle()
        }
        
        func setReuqest(_ request: Request) {
            
        }
    }
    
    private struct Default {
        static let sessionConfiguration = URLSessionConfiguration.default.then { (configuration) in }
        static let manager = Manager(configuration: sessionConfiguration)
        static let cache = ImageCache()
        
        private init() { }
    }
    
    let manager: Manager
    let cache: ImageCache
    let queue: DispatchQueue
    let processors: [ImageProcessor]
    let requestIntercept: ((URLRequest) -> URLRequest)?
    
    public static let shared = ImageDownloader()
    
    init(manager: Manager = Default.manager,
         cache: ImageCache = Default.cache,
         queue: DispatchQueue = .global(),
         processors: [ImageProcessor] = [],
         requestIntercept: ((URLRequest) -> URLRequest)? = nil)
    {
        self.manager = manager
        self.cache = cache
        self.queue = queue
        self.processors = processors
        self.requestIntercept = requestIntercept
    }
    
    func fetchImage(withURL url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        
        let cancelable = Cancelable()
        
        queue.async {
            if let image = self.memoryImage(withURL: url) {
                completionHandler(image)
                return
            }
            if let image = self.diskImage(withURL: url) {
                completionHandler(image)
                return
            }
            
            let originURLRequest = URLRequest(url: url)
            let urlRequest = self.requestIntercept?(originURLRequest) ?? originURLRequest
            let request = self.manager.sendRequest(urlRequest)
            
            
            request.response(self.queue) { (data, response, error) in
                guard error == nil, let response = response, let data = data, (200..<300).contains(response.statusCode) else {
                    completionHandler(nil)
                    return
                }
                
                var image = UIImage(data: data)
                for processor in self.processors {
                    guard let originImage = image else {
                        break
                    }
                    image = processor.process(originImage)
                }
                
                completionHandler(image)
            }
        }
    }
    
    func diskImage(withURL url: URL) -> UIImage? {
        return cache.diskCache.object(forKey: url.imageCacheKey)
    }
    
    func memoryImage(withURL url: URL) -> UIImage? {
        return cache.memoryCache.object(forKey: url.imageCacheKey)
    }
}
