//
//  Response.swift
//  Rubick
//
//  Created by WuFan on 16/9/25.
//
//

import Foundation

extension Request {
    @discardableResult
    public func response(_ queue: DispatchQueue = DispatchQueue.main,
                         completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) -> Self
    {
        handler.queue.addOperation {
            queue.async {
                completionHandler(self.handler.data, self.response, self.handler.error)
            }
        }
        return self
    }
}
