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
    static func name(for notification: Notification) -> String {
        return "\(self).\(notification.rawValue)"
    }
    
    public static func addObserver(
        _ observer: AnyObject,
        selector aSelector: Selector,
        notification aNotification: Notification,
        object anObject: AnyObject?)
    {
        NotificationCenter.default.addObserver(
            observer,
            selector: aSelector,
            name: Foundation.Notification.Name(name(for: aNotification)),
            object: anObject
        )
    }
    
    public static func post(notification aNotification: Notification, object anObject: AnyObject?) {
        NotificationCenter.default.post(name: Foundation.Notification.Name(name(for: aNotification)), object: anObject, userInfo: nil)
    }
    
    public static func post(notification aNotification: Notification, object anObject: AnyObject?, userInfo aUserInfo: [AnyHashable: Any]?) {
        NotificationCenter.default.post(name: Foundation.Notification.Name(name(for: aNotification)), object: anObject, userInfo: aUserInfo)
    }
    
    public static func removeObserver(_ observer: AnyObject, notification aNotification: Notification, object anObject: AnyObject?) {
        NotificationCenter.default.removeObserver(observer, name: Foundation.Notification.Name(name(for: aNotification)), object: anObject)
    }
}
