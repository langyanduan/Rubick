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
    func asURLRequest() throws -> URLRequest
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
    func asURLRequest() throws -> URLRequest {
        guard let baseURL = URL(string: self.baseURL) else {
            throw HTTPError.url
        }
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        
        var headerFields = self.headerFields ?? [:]
        if let bodyParameters = bodyParameters {
            headerFields["Content-Type"] = bodyParameters.contentType
            
            do {
                let body = try bodyParameters.build()
                switch body {
                case .data(let data):
                    request.httpBody = data
                case .inputStream(let stream):
                    request.httpBodyStream = stream
                }
            }
        }
        
        if let queryParameters = queryParameters {
            guard let URLComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                throw HTTPError.url
            }
            
            request.url = URLComponents.url
        } else {
            request.url = url
        }
        
        
        request.allHTTPHeaderFields = headerFields
        request.httpMethod = method.rawValue
        
        return request
    }
}
