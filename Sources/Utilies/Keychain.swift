//
//  Keychain.swift
//  Rubick
//
//  Created by WuFan on 2016/9/27.
//
//

import Foundation
import Security

private let defaultService = "com.rubick"

public class Keychain {
    public static let shared = Keychain(service: defaultService)
    
    public let service: String
    public init(service: String) {
        self.service = service
    }
    
    public subscript(account: String) -> String? {
        get {
            return password(forAccount: account)
        }
        set {
            if let password = newValue {
                set(password: password, forAccount: account)
            } else {
                delete(forAccount: account)
            }
        }
    }
    
    public func password(forAccount account: String) -> String? {
        let query: [String: String] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        var result: CFTypeRef?
        
        SecItemCopyMatching(query as CFDictionary, &result)
        
        return nil
    }
    
    public func set(password: String, forAccount account: String) {
        
    }
    
    public func delete(forAccount account: String) {
        
    }
    
}
