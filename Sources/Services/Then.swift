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
    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let label = UILabel().then {
    ///       $0.textAlignment = .Center
    ///       $0.textColor = UIColor.blackColor()
    ///       $0.text = "Hello, World!"
    ///     }
    public func then(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension Then where Self: Any {
    public func with(_ closure: (inout Self) -> Void) -> Self {
        var copy = self
        closure(&copy)
        return copy
    }
}


extension NSObject: Then { }


