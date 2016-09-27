//
//  KeychainTests.swift
//  Rubick
//
//  Created by WuFan on 2016/9/27.
//
//

import XCTest
@testable import Rubick

class KeychainTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAccessGroup() {
        let keychain = Keychain(accessGroup: "BLU32697WN.com.dacai.RubickHostApp")
        let account = "abcdefg"
        let password = "12345678"
        
        _ = try? keychain.delete(forAccount: account)
        
        do {
            try keychain.set(password: password, forAccount: account)
            let pwd = try keychain.password(forAccount: account)
            try keychain.delete(forAccount: account)
            
            XCTAssert(pwd == password)
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func testErrorAccessGroup() {
        let keychain = Keychain(accessGroup: "BLU32697WN.com.dacai.unknown")
        let account = "abcdefg"
        let password = "12345678"
        
        _ = try? keychain.delete(forAccount: account)
        
        do {
            try keychain.set(password: password, forAccount: account)
            _ = try keychain.password(forAccount: account)
            try keychain.delete(forAccount: account)
            
            XCTFail()
        } catch let KeychainError.unhandledError(status) {
            keychain.printOSStatus(status)
            XCTAssert(status == -34018) // hard code in iOS 10
        } catch {
            XCTFail()
        }
        
    }
}
