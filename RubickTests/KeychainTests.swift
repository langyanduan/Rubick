//
//  KeychainTests.swift
//  Rubick
//
//  Created by WuFan on 2016/9/27.
//
//

import XCTest
import Rubick

class KeychainTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetPassword() {
        Keychain.shared.set(password: "aaaa", forAccount: "bbbbb")
    }
}
