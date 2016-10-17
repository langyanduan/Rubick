//
//  Reachability.swift
//  Rubick
//
//  Created by WuFan on 2016/10/14.
//
//
//  from: https://developer.apple.com/library/content/samplecode/Reachability/Introduction/Intro.html

import Foundation
import SystemConfiguration

public enum NetworkStatus {
    case notReachable
    case reachableViaWiFi
    case reachableViaWWAN
}

public class Reachability {
    private let reachability: SCNetworkReachability
    public var listenerQueue: DispatchQueue = .main
    
    public init?(hostName: String) {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, hostName) else { return nil }
        self.reachability = reachability
    }
    
    public init?(hostAddress: sockaddr) {
        var hostAddress = hostAddress
        guard let reachability = SCNetworkReachabilityCreateWithAddress(nil, &hostAddress) else { return nil }
        self.reachability = reachability
    }
    
    public init?() {
        var address = sockaddr_in()
        address.sin_len = __uint8_t(MemoryLayout<sockaddr_in>.size)
        address.sin_family = sa_family_t(AF_INET)
        
        guard let reachability = withUnsafePointer(to: &address, { (ptr) in
            return ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                return SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else { return nil }
        
        self.reachability = reachability
    }
    
    deinit {
        stopListening()
    }
    
    // status
    private func status(for flags: SCNetworkReachabilityFlags) -> NetworkStatus {
        if !flags.contains(.reachable) {
            return .notReachable
        }
        
        var status = NetworkStatus.notReachable
        if !flags.contains(.connectionRequired) {
            status = .reachableViaWiFi
        }
        
        if flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic) {
            if !flags.contains(.interventionRequired) {
                status = .reachableViaWiFi
            }
        }
        
        if flags.contains(.isWWAN) {
            status = .reachableViaWWAN
        }

        return status
    }
    
    public var status: NetworkStatus {
        var flags: SCNetworkReachabilityFlags = []
        SCNetworkReachabilityGetFlags(reachability, &flags)
        return status(for: flags)
    }
    
    public var isReachable: Bool {
        return status == .reachableViaWiFi || status == .reachableViaWWAN
    }
    
    // notify
    public func startListening() {
        var object = self
        var info = withUnsafeMutablePointer(to: &object) { UnsafeMutableRawPointer($0) }
        var context = SCNetworkReachabilityContext(version: 0, info: info, retain: nil, release: nil, copyDescription: nil)
        let callback: SCNetworkReachabilityCallBack = { (reachability, flags, info) in
            guard let object = info?.assumingMemoryBound(to: Reachability.self).pointee else { return }
            object.statusChanged()
        }
        SCNetworkReachabilitySetCallback(reachability, callback, &context)
        SCNetworkReachabilitySetDispatchQueue(reachability, listenerQueue)
        statusChanged()
    }
    
    public func stopListening() {
        SCNetworkReachabilitySetDispatchQueue(reachability, listenerQueue)
    }
    
    public func statusChanged() {
        NotificationCenter.default.post(name: Notification.Name.Rubick.ReachabilityChanged, object: self)
    }
}
