//
//  BodyParameters.swift
//  Rubick
//
//  Created by WuFan on 16/9/8.
//
//

import Foundation

public enum RequestBody {
    case data(Foundation.Data)
    case inputStream(Foundation.InputStream)
}

public protocol BodyParametersType {
    var contentType: String { get }
    func build() throws -> RequestBody
}

public struct JSONParameters: BodyParametersType {
    var parameters: [String: AnyObject]
    
    public init(parameters: [String: AnyObject]) {
        self.parameters = parameters
    }
    
    public var contentType: String {
        return "application/json"
    }
    
    public func build() throws -> RequestBody {
        do {
            return .data(try JSONSerialization.data(withJSONObject: parameters, options: []))
        } catch {
            throw HTTPError.encoding
        }
    }
}

public struct FormURLParameters: BodyParametersType {
    var parameters: [String: AnyObject]
    
    public init(parameters: [String: AnyObject]) {
        self.parameters = parameters
    }
    
    public var contentType: String {
        return "application/x-www-form-urlencoded"
    }
    
    public func build() throws -> RequestBody {
        fatalError("FromURLParameters.build() has not been implemented")
    }
}
