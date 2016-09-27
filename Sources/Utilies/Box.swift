//
//  Box.swift
//  Rubick
//
//  Created by WuFan on 16/9/19.
//
//

import Foundation

public struct Box<T> {
    let value: T
    public init(_ value: T) {
        self.value = value
    }
}
