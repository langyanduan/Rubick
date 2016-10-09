//
//  Box.swift
//  Rubick
//
//  Created by WuFan on 16/9/19.
//
//

import Foundation

public final class Box<T> {
    let value: T
    public init(_ value: T) {
        self.value = value
    }
}

public final class MutableBox<T> {
    var value: T
    public init(_ value: T) {
        self.value = value
    }
}
