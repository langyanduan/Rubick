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
    
    public static func addObserver(observer: AnyObject, selector aSelector: Selector, notification aNotification: Notification, object anObject: AnyObject?) {
        let name = notificationName(for: aNotification)
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(observer, selector: aSelector, name: name, object: anObject)
    }
    
    public static func postNotification(aNotification: Notification, object anObject: AnyObject?) {
        postNotification(aNotification, object: anObject, userInfo: nil)
    }
    
    public static func postNotification(aNotification: Notification, object anObject: AnyObject?, userInfo aUserInfo: [NSObject : AnyObject]?) {
        let name = notificationName(for: aNotification)
        let center = NSNotificationCenter.defaultCenter()
        center.postNotificationName(name, object: anObject, userInfo: aUserInfo)
    }
    
    public static func removeObserver(observer: AnyObject, notification aNotification: Notification, object anObject: AnyObject?) {
        let name = notificationName(for: aNotification)
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(observer, name: name, object: anObject)
    }
}