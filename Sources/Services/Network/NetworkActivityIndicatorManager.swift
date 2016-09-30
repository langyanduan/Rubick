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
    
    private let lock: NSLock = NSLock()
    private var enable = true
    private var activityCount = 0
    
    private var timer: CFRunLoopTimer?
    private var activityDate: CFAbsoluteTime = 0
    
    public var leastDuration: TimeInterval = 0.2
    public var isNetworkActivityIndicatorVisible: Bool = false {
        didSet {
            let visible = isNetworkActivityIndicatorVisible
            guard visible != oldValue else { return }
            asyncOnMainQueue {
                UIApplication.shared.isNetworkActivityIndicatorVisible = visible
            }
        }
    }
    
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
        
        if let timer = self.timer {
            CFRunLoopTimerInvalidate(timer)
            self.timer = nil
        }
        
        if activityCount == 0 {
            guard isNetworkActivityIndicatorVisible else { return }
            
            let currentDate = CFAbsoluteTimeGetCurrent()
            let delay = leastDuration - (currentDate - activityDate)
            if delay > Double.leastNonzeroMagnitude {
                timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, currentDate + delay, 0, 0, 0) { [weak self] _ in
                    guard let `self` = self else { return }
                    self.lock.lock()
                    self.isNetworkActivityIndicatorVisible = false
                    self.timer = nil
                    self.lock.unlock()
                }
                CFRunLoopAddTimer(CFRunLoopGetMain(), timer, CFRunLoopMode.commonModes)
            } else {
                isNetworkActivityIndicatorVisible = false
            }
        } else {
            activityDate = CFAbsoluteTimeGetCurrent()
            isNetworkActivityIndicatorVisible = true
        }
    }
}
