//
//  Notification.swift
//  Rubick
//
//  Created by WuFan on 16/9/25.
//
//

import Foundation

extension Notification.Name {
    struct Rubick {
        static let RequestDidResume = Notification.Name("com.rubick.RequestDidResume")
        static let RequestDidSuspend = Notification.Name("com.rubick.RequestDidSuspend")
        static let RequestDidCancel = Notification.Name("com.rubick.RequestDidCancel")
        static let RequestDidComplete = Notification.Name("com.rubick.RequestDidComplete")
    }
}
