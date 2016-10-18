//
//  Box.swift
//  Rubick
//
//  Created by WuFan on 16/9/19.
//
//

import Foundation

public final class Box<T> {
    public let value: T
    public init(_ value: T) {
        self.value = value
    }
}

public final class MutableBox<T> {
    public var value: T
    public init(_ value: T) {
        self.value = value
    }
}

public final class WeakBox<T: AnyObject> {
    public private(set) weak var value: T?
    public init(_ value: T) {
        self.value = value
    }
}

public final class WeakMutableBox<T: AnyObject> {
    public weak var value: T?
    public init(_ value: T) {
        self.value = value
    }
}
