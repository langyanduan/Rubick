//
//  Error.swift
//  Rubick
//
//  Created by WuFan on 16/9/8.
//
//

import Foundation


public enum Error: ErrorType {
    case URL
    case Encoding
    case Response
    case Parser
    
    case NSError(Foundation.NSError)
    
    case Custom(String)
    
    public init(_ error: ErrorType) {
        switch error {
        case let error as Error:
            self = error
        case let error as Foundation.NSError:
            self = .NSError(error)
        default:
            self = .Custom("Unknown")
        }
    }
}