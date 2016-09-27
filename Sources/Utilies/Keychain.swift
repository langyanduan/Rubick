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

public enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

public class Keychain {
    public static let shared = Keychain(service: defaultService)
    
    public let accessGroup: String?
    public let service: String
    
    func buildQuery(withAccount account: String, options: NSDictionary? = nil) -> CFDictionary {
        let query = NSMutableDictionary()
        query[kSecAttrService] = service
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = account
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup] = accessGroup
        }
        options?.forEach { (key, value) in
            query[key] = value
        }
        return query
    }

    
    /// Create a keychain object.
    ///
    /// - parameter service:     service name
    /// - parameter accessGroup: "[YOUR APP ID PREFIX].com.example.apple-samplecode.GenericKeychainShared"
    ///
    public init(service: String = defaultService, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }
    
    public subscript(account: String) -> String? {
        get {
            return try? password(forAccount: account)
        }
        set {
            if let password = newValue {
                _ = try? set(password: password, forAccount: account)
            } else {
                _ = try? delete(forAccount: account)
            }
        }
    }
    
    public func password(forAccount account: String) throws -> String {
        let query = buildQuery(withAccount: account, options: [
            kSecReturnAttributes: kCFBooleanTrue,
            kSecReturnData: kCFBooleanTrue
        ])
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Parse the password string from the query result.
        guard let existingItem = queryResult as? [String : AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedPasswordData
        }
        
        return password
    }
    
    public func set(password: String, forAccount account: String) throws {
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do {
            // Check for an existing item in the keychain.
            _ = try self.password(forAccount: account)
            
            // Update the existing item with the new password.
            let attributesToUpdate: NSDictionary = [ kSecValueData: encodedPassword ]
            let query = buildQuery(withAccount: account)
            let status = SecItemUpdate(query, attributesToUpdate as CFDictionary)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
            
        } catch KeychainError.noPassword {
            let query = buildQuery(withAccount: account, options: [
                kSecValueData: encodedPassword
            ])
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(query, nil)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    public func delete(forAccount account: String) throws {
        // Delete the existing item from the keychain.
        let query = buildQuery(withAccount: account)
        let status = SecItemDelete(query)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    #if DEBUG
    
    func printOSStatus(_ status: OSStatus) {
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
    
    #endif
}
