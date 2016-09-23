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

public struct ImageDownloader {
    public class Cancelable {
//        fileprivate private(set) var completeHandler: ((Void) -> Void)?
        
        fileprivate var request: Request? {
            get { _lock.lock(); defer { _lock.unlock() }; return _request }
            set { _lock.lock(); defer { _lock.unlock() }; _request = newValue }
        }
        fileprivate var handleCanceled: Bool {
            get { _lock.lock(); defer { _lock.unlock() }; return _handleCanceled }
            set { _lock.lock(); defer { _lock.unlock() }; _handleCanceled = newValue }
        }
        fileprivate var downloadCanceled: Bool {
            get { _lock.lock(); defer { _lock.unlock() }; return _downloadCanceled }
            set { _lock.lock(); defer { _lock.unlock() }; _downloadCanceled = newValue }
        }
        
        
        private let _lock = NSLock()
        private var _request: Request?
        private var _downloadCanceled: Bool = false
        private var _handleCanceled: Bool = false
        
        private func cancelDownload() {
            guard !_downloadCanceled else {
                return
            }
            _downloadCanceled = true
            _request?.cancel()
        }
        private func cancelHandle() {
            guard !_handleCanceled else {
                return
            }
            _handleCanceled = true
        }
        
        public func cancel(alsoDownload: Bool = false) {
            _lock.lock(); defer { _lock.unlock() }
            
            cancelHandle()
            if alsoDownload {
                cancelDownload()
            }
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
    
    func fetchImage(withURL url: URL, completionHandler: @escaping (UIImage?, Bool) -> Void) -> Cancelable {
        let cancelable = Cancelable()
        
        func processAndCacheImage(_ image: UIImage?) -> UIImage? {
            var image = image
            for processor in self.processors {
                guard let originImage = image else {
                    break
                }
                image = processor.process(originImage)
            }
            if let image = image {
                self.cache.setMemoryImage(image, forURL: url)
            }
            return image
        }
        
        queue.async {
            if let image = self.cache.memoryImage(withURL: url) {
                completionHandler(image, cancelable.handleCanceled)
                return
            }
            
            if let image = self.cache.diskImage(withURL: url) {
                completionHandler(processAndCacheImage(image), cancelable.handleCanceled)
                return
            }
            
            if cancelable.downloadCanceled {
                completionHandler(nil, true)
                return
            }
            
            let originURLRequest = URLRequest(url: url)
            let urlRequest = self.requestIntercept?(originURLRequest) ?? originURLRequest
            let request = self.manager.sendRequest(urlRequest)
            
            cancelable.request = request
            
            request.response(self.queue) { (data, response, error) in
                if cancelable.downloadCanceled {
                    completionHandler(nil, true)
                    return
                }
                
                guard error == nil, let response = response, let data = data, (200..<300).contains(response.statusCode) else {
                    completionHandler(nil, false)
                    return
                }
                
                guard let image = ImageDecoder.image(fromBytes: data) else {
                    completionHandler(nil, false)
                    return
                }
                
                self.cache.setDiskImage(image, forURL: url)
                completionHandler(processAndCacheImage(image), cancelable.handleCanceled)
            }
        }
        
        return cancelable
    }
}
