//
//  RequestType.swift
//  Rubick
//
//  Created by WuFan on 16/9/8.
//
//

import Foundation

public enum Method: String {
    case GET
    case POST
    case PUT
    case HEAD
    case DELETE
    case PATCH
    case TRACE
    case OPTIONS
    case CONNECT
    
    var prefersQueryParameters: Bool {
        switch self {
        case .GET, .HEAD, .DELETE:
            return true
        default:
            return false
        }
    }
}

public protocol URLRequestConvertible {
    func asURLRequest() throws -> NSMutableURLRequest
}

public protocol RequestType: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var headerFields: [String: String]? { get }
    var queryParameters: [String: AnyObject]? { get }
    var bodyParameters: BodyParametersType? { get }
    var method: Method { get }
}

public extension RequestType {
    func asURLRequest() throws -> NSMutableURLRequest {
        guard let baseURL = NSURL(string: self.baseURL) else {
            throw Error.URL
        }
        let URL = baseURL.URLByAppendingPathComponent(path)
        let URLRequest = NSMutableURLRequest()
        
        var headerFields = self.headerFields ?? [:]
        if let bodyParameters = bodyParameters {
            headerFields["Content-Type"] = bodyParameters.contentType
            
            do {
                let body = try bodyParameters.build()
                switch body {
                case .Data(let data):
                    URLRequest.HTTPBody = data
                case .InputStream(let stream):
                    URLRequest.HTTPBodyStream = stream
                }
            }
        }
        
        if let queryParameters = queryParameters {
            guard let URLComponents = NSURLComponents(URL: URL, resolvingAgainstBaseURL: false) else {
                throw Error.URL
            }
            
            URLRequest.URL = URLComponents.URL
        } else {
            URLRequest.URL = URL
        }
        
        
        URLRequest.allHTTPHeaderFields = headerFields
        URLRequest.HTTPMethod = method.rawValue
        
        return URLRequest
    }
}
