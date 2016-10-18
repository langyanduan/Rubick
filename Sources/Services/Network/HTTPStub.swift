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
    
    public init?(
        urlString: String,
        response: @escaping (URLRequest) -> (HTTPURLResponse?, Data?, Error?),
        delay: TimeInterval = 0.5)
    {
        guard let _ = URL(string: urlString) else {
            return nil
        }
        
        self.urlString = urlString
        self.response = response
        self.delay = delay
    }
    
    public init?(
        urlString: String,
        statusCode: Int = 200,
        contentType: String? = nil,
        data: Data,
        delay: TimeInterval = 0.5)
    {
        let response = { (request: URLRequest) -> (HTTPURLResponse?, Data?, Error?) in
            let headerFields: [String: String] = contentType == nil ? [:] : ["ContentType": contentType!]
            return (HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "1.1", headerFields: headerFields), data, nil)
        }
        
        self.init(urlString: urlString, response: response, delay: delay)
    }
    
    public init?(
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
    
    @discardableResult
    public static func add(urlString: String, data: Data, contentType: String? = nil, delay: TimeInterval = 0.5) -> Bool {
        guard let stub = HTTPStub(urlString: urlString, contentType: contentType, data: data, delay: delay) else {
            return false
        }
        add(stub: stub)
        return true
    }
}

class StubProtocol: URLProtocol {
    var isStopped = false
    
    class func compareURLString(_ l: String?, _ r: String?) -> Bool {
        guard var l = l, var r = r else { return false }
        if let index = l.characters.index(of: Character("?")) { l = l.substring(to: index) }
        if let index = r.characters.index(of: Character("?")) { r = r.substring(to: index) }
        return r == l
    }
    
    // override
    override class func canInit(with request: URLRequest) -> Bool {
        pthread_mutex_lock(&lock); defer { pthread_mutex_unlock(&lock) }
        return stubSets.first { compareURLString(request.url?.absoluteString, $0.urlString) } != nil
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        pthread_mutex_lock(&lock)
        let optionalStub = stubSets.first { StubProtocol.compareURLString(request.url?.absoluteString, $0.urlString) }
        pthread_mutex_unlock(&lock)
        
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
            }
        }
    }
    
    override func stopLoading() {
        isStopped = false
    }
}
