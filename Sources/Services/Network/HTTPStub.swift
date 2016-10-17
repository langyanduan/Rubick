//
//  HTTPStub.swift
//  Rubick
//
//  Created by WuFan on 2016/10/14.
//
//

import Foundation

public struct HTTPStub {
    let urlString: String
    let response: (URLRequest) -> (HTTPURLResponse?, Data?, Error?)
    let delay: TimeInterval
    
    public init(
        urlString: String,
        response: @escaping (URLRequest) -> (HTTPURLResponse?, Data?, Error?),
        delay: TimeInterval = 0.5)
    {
        self.urlString = urlString
        self.response = response
        self.delay = delay
    }
    
    public init(
        urlString: String,
        statusCode: Int = 200,
        contentType: String,
        data: Data,
        delay: TimeInterval = 0.5)
    {
        let response = { (request: URLRequest) -> (HTTPURLResponse?, Data?, Error?) in
            return (HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "1.1", headerFields: ["ContentType": contentType]), data, nil)
        }
        
        self.init(urlString: urlString, response: response, delay: delay)
    }
    
    public init(
        urlString: String,
        statusCode: Int,
        error: Error?,
        data: Data?,
        delay: TimeInterval = 0.5)
    {
        let response = { (request: URLRequest) -> (HTTPURLResponse?, Data?, Error?) in
            return (HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "1.1", headerFields: nil), data, error)
        }
        self.init(urlString: urlString, response: response, delay: delay)
    }
}

extension HTTPStub: Hashable {
    public static func ==(lhs: HTTPStub, rhs: HTTPStub) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var hashValue: Int {
        return urlString.hashValue
    }
}

private var lock = pthread_mutex_t()
private var stubSets: Set<HTTPStub> = Set()
private var hasRegister = false
extension HTTPStub {
    public static func add(stub: HTTPStub) {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        stubSets.insert(stub)
        
        if !hasRegister {
            hasRegister = true
            URLProtocol.registerClass(StubProtocol.self)
        }
    }
}

class StubProtocol: URLProtocol {
    var isStopped = false
    
    // override
    override class func canInit(with request: URLRequest) -> Bool {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        return stubSets.first { request.url?.absoluteString == $0.urlString } != nil
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        pthread_mutex_lock(&lock)
        let optionalStub = stubSets.first { request.url?.absoluteString == $0.urlString }
        pthread_mutex_unlock(&lock)
        
        LogD("stub startLoading: \(request.url!)")
        
        guard let stub = optionalStub else {
            client?.urlProtocol(self, didFailWithError: NSError(domain: "com.rubick.httpstub", code: 0, userInfo: nil))
            return
        }
        
        asyncOnGlobalQueue(delay: stub.delay) {
            if self.isStopped { return }
            
            let response = stub.response(self.request)
            
            switch response {
            case (nil, _, nil):
                self.client?.urlProtocol(self, didFailWithError: NSError(domain: "com.rubick.httpstub", code: 0, userInfo: nil))
            case (nil, _, let error?):
                self.client?.urlProtocol(self, didFailWithError: error)
            case let (response?, data, nil):
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
                if let data = data {
                    self.client?.urlProtocol(self, didLoad: data)
                }
                self.client?.urlProtocolDidFinishLoading(self)
            case let (response?, data, error?):
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
                if let data = data {
                    self.client?.urlProtocol(self, didLoad: data)
                }
                self.client?.urlProtocol(self, didFailWithError: error)
            default:
                assertionFailure()
            }
        }
    }
    
    override func stopLoading() {
        LogD("stub stopLoading: \(request.url!)")
        
        isStopped = false
    }
}
