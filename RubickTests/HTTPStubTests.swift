//
//  HTTPStubTests.swift
//  Rubick
//
//  Created by WuFan on 2016/10/17.
//
//

import Foundation
import XCTest
@testable import Rubick

class HTTPStubTests: XCTestCase {
    
    let manager = Manager()
    
    override func setUp() {
        super.setUp()
        
        HTTPStub.add(urlString: "http://baidu.com", data: "abcdefg".data(using: .utf8)!)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testURLComponents() {
        var urlString = "http://baidu.com?abc=1"
        if let index = urlString.characters.index(of: Character("?")) {
            urlString = urlString.substring(to: index)
        }
        
        XCTAssert(urlString == "http://baidu.com")
    }
    
    
    func testGET() {
        let expectation = self.expectation(description: "stub failure")
        
        manager.request(URLRequest(url: URL(string: "http://baidu.com")!)).response { (data, response, error) in
            guard let data: Data = data, let text = String(data: data, encoding: .utf8) else {
                XCTFail()
                return
            }
            
            XCTAssert(text == "abcdefg")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGETParameters() {
        let expectation = self.expectation(description: "stub failure")
        
        manager.request(URLRequest(url: URL(string: "http://baidu.com?abc=1")!)).response { (data, response, error) in
            guard let data: Data = data, let text = String(data: data, encoding: .utf8) else {
                XCTFail()
                return
            }
            
            XCTAssert(text == "abcdefg")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
