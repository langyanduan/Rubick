//
//  Notification.swift
//  Rubick
//
//  Created by WuFan on 16/9/25.
//
//

import Foundation

extension Notification.Name {
    public struct Rubick {
        public static let RequestDidResume = Notification.Name("com.rubick.RequestDidResume")
        public static let RequestDidSuspend = Notification.Name("com.rubick.RequestDidSuspend")
        public static let RequestDidCancel = Notification.Name("com.rubick.RequestDidCancel")
        public static let RequestDidComplete = Notification.Name("com.rubick.RequestDidComplete")
    }
}
