//
//  ImageFetcher.swift
//  Rubick
//
//  Created by WuFan on 16/9/19.
//
//

import Foundation

public struct ImageDownloader {
    public class Task {
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
        
        public let url: URL
        
        init(url: URL) {
            self.url = url
        }
        
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
    
    public struct Default {
        static let sessionConfiguration = URLSessionConfiguration.default.then { (configuration) in
            configuration.timeoutIntervalForRequest = 10
            configuration.timeoutIntervalForResource = 10
        }
        public static let manager = Manager(configuration: sessionConfiguration)
        public static let cache = ImageCache()
        
        private init() { }
    }
    
    let manager: Manager
    let cache: ImageCache
    let decodeQueue: DispatchQueue
    let processors: [ImageProcessor]
    let requestIntercept: ((URLRequest) -> URLRequest)?
    
    public static let shared = ImageDownloader(cache: Default.cache)
    
    public init(manager: Manager = Default.manager,
                cache: ImageCache = ImageCache(),
                decodeQueue: DispatchQueue = .global(),
                processors: [ImageProcessor] = [],
                requestIntercept: ((URLRequest) -> URLRequest)? = nil)
    {
        assert(!decodeQueue.isMainQueue, "Please does not decode and process image in main queue.")
        
        self.manager = manager
        self.cache = cache
        self.decodeQueue = decodeQueue
        self.processors = processors
        self.requestIntercept = requestIntercept
    }
    
    @discardableResult
    public func fetchImage(
        withURL url: URL,
        queue: DispatchQueue = .main,
        processHandler: ((Int64, Int64) -> Void)? = nil,
        completionHandler: @escaping (UIImage?, Bool) -> Void)
        -> Task
    {
        let cancelable = Task(url: url)
        
        func processAndCacheImage(_ image: UIImage?) -> UIImage? {
            var image = image
            if processors.count == 0 {
                image = image?.ext.decoded()
            } else {
                for processor in self.processors {
                    guard let originImage = image else {
                        break
                    }
                    image = processor.process(originImage)
                }
            }
            
            if let image = image {
                self.cache.setMemoryImage(image, forURL: url)
            }
            return image
        }
        
        func completionOnSpecifiedQueue(_ image: UIImage?, _ canceled: Bool) {
            queue.async {
                completionHandler(image, canceled)
            }
        }
        
        decodeQueue.async {
            if let image = self.cache.memoryImage(withURL: url) {
                completionOnSpecifiedQueue(image, cancelable.handleCanceled)
                return
            }
            
            if let image = self.cache.diskImage(withURL: url) {
                completionOnSpecifiedQueue(processAndCacheImage(image), cancelable.handleCanceled)
                return
            }
            
            if cancelable.downloadCanceled {
                completionOnSpecifiedQueue(nil, true)
                return
            }
            
            let originURLRequest = URLRequest(url: url)
            let urlRequest = self.requestIntercept?(originURLRequest) ?? originURLRequest
            let request = self.manager.request(urlRequest)
            
            cancelable.request = request
            
            if let processHandler = processHandler {
                request.downloadProcess(queue: queue, process: processHandler)
            }
            request.response(self.decodeQueue) { (data, response, error) in
                if cancelable.downloadCanceled {
                    completionOnSpecifiedQueue(nil, true)
                    return
                }
                
                guard error == nil, let response = response, let data = data, (200..<300).contains(response.statusCode) else {
                    completionOnSpecifiedQueue(nil, false)
                    return
                }
                
                guard let image = ImageDecoder.image(fromData: data, scale: 1.0) else {
                    completionOnSpecifiedQueue(nil, false)
                    return
                }
                
                self.cache.setDiskImage(image, forURL: url)
                completionOnSpecifiedQueue(processAndCacheImage(image), cancelable.handleCanceled)
            }
        }
        
        
        return cancelable
    }
}
