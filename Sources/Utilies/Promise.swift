//
//  Then.swift
//  Rubick
//
//  Created by WuFan on 16/9/19.
//
//

import Foundation

public final class Promise<T> {
//    @discardableResult
//    public func then<X>(_ closure: (T) -> Void) -> Promise<X> {
//    }
//    
//    @discardableResult
//    public func onError<X>(_ closure: (Error) -> Void) -> Promise<X> {
//    }
//    
//    @discardableResult
//    public func finally<X>(_ closure: () -> Void) -> Promise<X> {
//    }
    

    
    
    public init(_ closure: ((T) -> Void, (Error) -> Void) -> Void) {
        
    }
}
