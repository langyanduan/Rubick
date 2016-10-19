//
//  CGRect+Extension.swift
//  Rubick
//
//  Created by WuFan on 2016/10/19.
//
//

import Foundation

extension InstanceExtension where Base: _CGRectType {
    private var _self: CGRect {
        return base as! CGRect
    }
}
