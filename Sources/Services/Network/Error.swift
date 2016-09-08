//
//  Error.swift
//  Rubick
//
//  Created by WuFan on 16/9/8.
//
//

import Foundation


public enum HTTPError: Error {
    case url
    case encoding
    case response
    case parser
    
    case custom(Any)
    
    public init(_ error: Error) {
        switch error {
        case let error as HTTPError:
            self = error
        default:
            self = .custom(error)
        }
    }
}
