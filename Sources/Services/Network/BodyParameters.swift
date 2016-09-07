//
//  BodyParameters.swift
//  Connect
//
//  Created by WuFan on 16/9/6.
//  Copyright © 2016年 dacai. All rights reserved.
//

import Foundation

public enum RequestBody {
    case Data(NSData)
    case InputStream(NSInputStream)
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
            return .Data(try NSJSONSerialization.dataWithJSONObject(parameters, options: []))
        } catch {
            throw Error.Encoding
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
        throw Error.Encoding
    }
}