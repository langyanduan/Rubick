//
//  DispatchQueue+Extension.swift
//  Rubick
//
//  Created by WuFan on 16/9/24.
//
//

import Foundation

extension DispatchQueue {
    var isMainQueue: Bool {
        return DispatchQueue.main === self
    }
}

public func asyncOnMainQueue(delay: TimeInterval = 0, execute work: @escaping () -> Void) {
    if delay > .leastNonzeroMagnitude {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
    } else {
        DispatchQueue.main.async(execute: work)
    }
}

public func asyncOnGlobalQueue(delay: TimeInterval = 0, execute work: @escaping () -> Void) {
    if delay > .leastNonzeroMagnitude {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay, execute: work)
    } else {
        DispatchQueue.global().async(execute: work)
    }
}
