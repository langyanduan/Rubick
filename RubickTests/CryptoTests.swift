//
//  CryptoTests.swift
//  Rubick
//
//  Created by WuFan on 16/9/27.
//
//

import XCTest
import Rubick

class CryptoTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testReadInputStream() {
        let data = Data(bytes: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
       
        XCTAssert(data.count == 10)
        
        let stream = InputStream(data: data)
        
        
        var read = [UInt8](repeating: 0, count: 10)
        
        stream.open()
        XCTAssert(stream.hasBytesAvailable)
        let c1 = stream.read(&read, maxLength: 5)
        XCTAssert(read[0] == 1 && read[4] == 5)
        
        let c2 = stream.read(&read, maxLength: 5)
        XCTAssert(read[0] == 6 && read[4] == 10)
        stream.close()
        
        XCTAssert(c1 == 5)
        XCTAssert(c2 == 5)
        
        XCTAssert(read[6] == 0)
    }
    
    func testGetBufferInputStream() {
        let data = Data(bytes: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
        
        XCTAssert(data.count == 10)
        
        let stream = InputStream(data: data)
        
        var buff: UnsafeMutablePointer<UInt8>?
        var len = 0
        let result = stream.getBuffer(&buff, length: &len)
        
        stream.open()
        XCTAssert(result)
    }
    
    func testMD5() {
        let data: [UInt8] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        let md5 = Digest(algorithm: .md5).update(fromBytes: data).final()
        let result = "8596C1AF55B14B7B320112944FCB8536"
        
        XCTAssert(md5.ext.hexString() == result)
        XCTAssert(md5.count == Digest.Algorithm.md5.digestLength)
    }
}
