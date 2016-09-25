//
//  NetworkActivityIndicatorManager.swift
//  Rubick
//
//  Created by WuFan on 16/9/8.
//
//

import Foundation

private extension Selector {
    static let RequestDidStart: Selector = #selector(NetworkActivityIndicatorManager.requestDidStart)
    static let RequestDidStop: Selector = #selector(NetworkActivityIndicatorManager.requestDidStop)
}

public class NetworkActivityIndicatorManager {
    private init() {
        NotificationCenter.default.addObserver(self, selector: .RequestDidStart, name: Notification.Name.Rubick.RequestDidResume, object: nil)
        NotificationCenter.default.addObserver(self, selector: .RequestDidStop, name: Notification.Name.Rubick.RequestDidSuspend, object: nil)
        NotificationCenter.default.addObserver(self, selector: .RequestDidStop, name: Notification.Name.Rubick.RequestDidComplete, object: nil)
        NotificationCenter.default.addObserver(self, selector: .RequestDidStop, name: Notification.Name.Rubick.RequestDidCancel, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public static let shared = NetworkActivityIndicatorManager()
    public var isEnable: Bool {
        get {
            lock.lock(); defer { lock.unlock() }
            return enable
        }
        set {
            lock.lock(); defer { lock.unlock() }
            enable = newValue
        }
    }
    
    private var enable = true
    private var activityCount = 0
    private let lock: NSLock = NSLock()
    
    @objc
    fileprivate func requestDidStart() {
        incrementActivityCount()
    }
    
    @objc
    fileprivate func requestDidStop() {
        decrementActivityCount()
    }
    
    func incrementActivityCount() {
        lock.lock(); defer { lock.unlock() }
        
        activityCount += 1
        updateActivityIndicatorState()
    }
    
    func decrementActivityCount() {
        lock.lock(); defer { lock.unlock() }
        
        guard activityCount > 0 else {
            return
        }
        
        activityCount -= 1
        updateActivityIndicatorState()
    }
    
    private func updateActivityIndicatorState() {
        guard enable else {
            return
        }
        
    }
}
