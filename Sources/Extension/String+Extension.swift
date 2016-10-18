//
//  String+Extension.swift
//  Rubick
//
//  Created by WuFan on 2016/9/23.
//
//

import Foundation

extension InstanceExtension where Base: _StringType {
    private var _self: String { return base as! String }
    
    public var count: Int {
        return _self.characters.count
    }
    
    public var lastPathComponent: String {
        return (_self as NSString).lastPathComponent
    }
    
    public func appendingPathComponent(_ str: String) -> String {
        return (_self as NSString).appendingPathComponent(str)
    }
}
