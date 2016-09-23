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

struct ImageDownloader {
    class Cancelable {
        private var request: Request
        private var downloadCanceled: Bool = false
        private var completeHandler: ((UIImage) -> Void)?
        
        init(request: Request, completeHandler: @escaping ((UIImage) -> Void)) {
            self.request = request
            self.completeHandler = completeHandler
        }
        
        func cancelDownload() {
            guard !downloadCanceled else {
                return
            }
            downloadCanceled = true
            request.cancel()
        }
        func cancelHandle() {
            guard completeHandler != nil else {
                return
            }
            completeHandler = nil
        }
        
        func cancelAll() {
            cancelDownload()
            cancelHandle()
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
    let process: [ImageProcessor]
    let requestIntercept: ((URLRequest) -> URLRequest)?
    
    public static let shared = ImageDownloader()
    
    init(manager: Manager = Default.manager,
         cache: ImageCache = Default.cache,
         queue: DispatchQueue = .global(),
         process: [ImageProcessor] = [],
         requestIntercept: ((URLRequest) -> URLRequest)? = nil)
    {
        self.manager = manager
        self.cache = cache
        self.queue = queue
        self.process = process
        self.requestIntercept = requestIntercept
    }
    
    func fetchImage(withURL url: URL, completionHandler: (UIImage) -> Void) {
        queue.async {
            if let image = self.fetchImageOnlyMemory(withURL: url) {
                
                return
            }
            if let image = self.fetchImageOnlyDisk(withURL: url) {
                
                return
            }
            
            let originURLRequest = URLRequest(url: url)
            let urlRequest = self.requestIntercept?(originURLRequest) ?? originURLRequest
            let request = self.manager.sendRequest(urlRequest)
            
            request.response(self.queue) { (data, response, error) in
                
            }
        }
    }
    
    func fetchImageOnlyDisk(withURL url: URL) -> UIImage? {
        return nil
    }
    
    func fetchImageOnlyMemory(withURL url: URL) -> UIImage? {
        return nil
    }
    
}
