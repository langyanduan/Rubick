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
    
    private func printOSStatus(_ status: OSStatus) {
        switch status {
        case errSecSuccess:
            print("errSecSuccess")
        case errSecUnimplemented:
            print("errSecUnimplemented")
        case errSecIO:
            print("errSecIO")
        case errSecOpWr:
            print("errSecOpWr")
        case errSecParam:
            print("errSecParam")
        case errSecAllocate:
            print("errSecAllocate")
        case errSecUserCanceled:
            print("errSecUserCanceled")
        case errSecBadReq:
            print("errSecBadReq")
        case errSecInternalComponent:
            print("errSecInternalComponent")
        case errSecNotAvailable:
            print("errSecNotAvailable")
        case errSecDuplicateItem:
            print("errSecDuplicateItem")
        case errSecItemNotFound:
            print("errSecItemNotFound")
        case errSecInteractionNotAllowed:
            print("errSecInteractionNotAllowed")
        case errSecDecode:
            print("errSecDecode")
        case errSecAuthFailed:
            print("errSecAuthFailed")
        case errSecVerifyFailed:
            print("errSecVerifyFailed")
        case let code:
            print("unknown status: \(code)")
        }
    }
    
    public func set(password: String, forAccount account: String) {
        let query: [String: String] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print("copy matching result:")
        printOSStatus(status)
        
        if errSecItemNotFound == status {
            let addQuery: [String: String] = [
                kSecClass as String: kSecClassGenericPassword as String,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account,
                kSecValueData as String: password
            ]
            
            let status = SecItemAdd(addQuery as CFDictionary, nil)
            print("add item result:")
            printOSStatus(status)
        } else if errSecSuccess == status {
            
        }
        
        
        
        
        
        print("end")
        
    }
    
    public func delete(forAccount account: String) {
        
    }
    
}
