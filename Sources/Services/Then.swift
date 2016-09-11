//
//  Then.swift
//  Rubick
//
//  Created by WuFan on 16/9/11.
//
//

import Foundation

public protocol Then { }

extension Then where Self: AnyObject {
    public func then(closure: @noescape (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: Then { }


