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
        Request.addObserver(self, selector: .RequestDidStart, notification: .DidResume, object: nil)
        Request.addObserver(self, selector: .RequestDidStop, notification: .DidCancel, object: nil)
        Request.addObserver(self, selector: .RequestDidStop, notification: .DidSuspend, object: nil)
        Request.addObserver(self, selector: .RequestDidStop, notification: .DidComplete, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public static let sharedManager = NetworkActivityIndicatorManager()
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
    private func requestDidStart() {
        incrementActivityCount()
    }
    
    @objc
    private func requestDidStop() {
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