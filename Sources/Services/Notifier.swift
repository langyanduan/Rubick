//
//  Notifier.swift
//  Rubick
//
//  Created by WuFan on 16/9/7.
//
//

import Foundation

public protocol Notifier {
    associatedtype Notification: RawRepresentable
}

public extension Notifier where Notification.RawValue == String {
    static func notificationName(for notification: Notification) -> String {
        return "\(self).\(notification.rawValue)"
    }
    
    public static func addObserver(_ observer: AnyObject, selector aSelector: Selector, notification aNotification: Notification, object anObject: AnyObject?) {
        let name = notificationName(for: aNotification)
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: Foundation.Notification.Name(rawValue: name), object: anObject)
    }
    
    public static func post(notification aNotification: Notification, object anObject: AnyObject?) {
        post(notification: aNotification, object: anObject, userInfo: nil)
    }
    
    public static func post(notification aNotification: Notification, object anObject: AnyObject?, userInfo aUserInfo: [AnyHashable: Any]?) {
        let name = notificationName(for: aNotification)
        // NotificationCenter.default.post(name: Foundation.Notification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: name), object: anObject, userInfo: aUserInfo)
    }
    
    public static func removeObserver(_ observer: AnyObject, notification aNotification: Notification, object anObject: AnyObject?) {
        let name = notificationName(for: aNotification)
        NotificationCenter.default.removeObserver(observer, name: Foundation.Notification.Name(rawValue: name), object: anObject)
    }
}
