//
//  LruCacheTests.swift
//  Rubick
//
//  Created by WuFan on 2016/9/26.
//
//

import XCTest
@testable import Rubick

private var deinitCount = 0

private func ==(lhs: O, rhs: O) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

private class O: Hashable {
    let hashValue: Int
    let value: Int
    
    init(_ value: Int) {
        self.value = value
        self.hashValue = Int(arc4random_uniform(0xffffffff))
    }
    
    deinit {
        deinitCount += 1
        print("O: \(value) deinit")
    }
}

class LruCacheTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetSet() {
        let cache = LruCache<Int, Int>()
        
        for i in 0..<10 {
            cache.set(value: i, forKey: i)
        }
        
        for i in 0..<10 {
            XCTAssert(i == cache.value(forKey: i))
        }
        
        XCTAssert(cache.count == 10)
    }
    
    func testCountTrim() {
        let cache = LruCache<String, Int>(countLimit: 3)
        
        cache.set(value: 1, forKey: "1")
        cache.set(value: 2, forKey: "2")
        cache.set(value: 3, forKey: "3")
        cache.set(value: 4, forKey: "4")
        cache.set(value: 5, forKey: "5")
        cache.set(value: 6, forKey: "6")
        cache.set(value: 7, forKey: "7")
        cache.set(value: 8, forKey: "8")
        
        cache.trim()
        
        XCTAssert(cache.count == 3)
        XCTAssert(cache.contains("6"))
        XCTAssert(cache.contains("7"))
        XCTAssert(cache.contains("8"))
    }
    
    func testTrimAge() {
        let cache = LruCache<String, Int>()
       
        
        print(CACurrentMediaTime())
        cache.set(value: 1, forKey: "1")
        cache.set(value: 2, forKey: "2")
        cache.set(value: 3, forKey: "3")
        cache.set(value: 4, forKey: "4")
        cache.set(value: 5, forKey: "5")
        Thread.sleep(forTimeInterval: 1)
        cache.set(value: 6, forKey: "6")
        cache.set(value: 7, forKey: "7")
        cache.set(value: 8, forKey: "8")
        print(CACurrentMediaTime())
        
        cache.trim(toAge: 0.5)
        
        XCTAssert(cache.count == 3)
    }
    
    func testTrimAgeAllTimeout() {
        let cache = LruCache<String, Int>()
        
        
        print(CACurrentMediaTime())
        cache.set(value: 1, forKey: "1")
        cache.set(value: 2, forKey: "2")
        cache.set(value: 3, forKey: "3")
        cache.set(value: 4, forKey: "4")
        cache.set(value: 5, forKey: "5")
        Thread.sleep(forTimeInterval: 0.5)
        cache.set(value: 6, forKey: "6")
        cache.set(value: 7, forKey: "7")
        cache.set(value: 8, forKey: "8")
        Thread.sleep(forTimeInterval: 0.5)
        print(CACurrentMediaTime())
        
        cache.trim(toAge: 0.4)
        
        XCTAssert(cache.count == 0)
    }
    
    func testTrimAgeWithoutTimeout() {
        let cache = LruCache<String, Int>()
        
        
        print(CACurrentMediaTime())
        cache.set(value: 1, forKey: "1")
        cache.set(value: 2, forKey: "2")
        cache.set(value: 3, forKey: "3")
        cache.set(value: 4, forKey: "4")
        cache.set(value: 5, forKey: "5")
        Thread.sleep(forTimeInterval: 1)
        cache.set(value: 6, forKey: "6")
        cache.set(value: 7, forKey: "7")
        cache.set(value: 8, forKey: "8")
        print(CACurrentMediaTime())
        
        cache.trim(toAge: 2)
        
        XCTAssert(cache.count == 8)
    }
    
    func testTrimAndGet() {
        let cache = LruCache<String, Int>()
        
        cache.set(value: 1, forKey: "1")
        cache.set(value: 2, forKey: "2")
        cache.set(value: 3, forKey: "3")
        cache.set(value: 4, forKey: "4")
        cache.set(value: 5, forKey: "5")
        cache.set(value: 6, forKey: "6")
        cache.set(value: 7, forKey: "7")
        cache.set(value: 8, forKey: "8")
        
        
        XCTAssert(cache.value(forKey: "1") == 1)
        XCTAssert(cache.value(forKey: "8") == 8)
        XCTAssert(cache.value(forKey: "4") == 4)
        
        cache.trim()
        XCTAssert(cache.count == 8)
        
        cache.trim(toCount: 3)
        XCTAssert(cache.count == 3)
        XCTAssert(cache.contains("1"))
        XCTAssert(cache.contains("8"))
        XCTAssert(cache.contains("4"))
        
        cache.trim(toCount: 1)
        XCTAssert(cache.contains("4"))
    }
    
    func testRemove() {
        let cache = LruCache<String, Int>()
        
        cache.set(value: 1, forKey: "1")
        cache.set(value: 2, forKey: "2")
        cache.set(value: 3, forKey: "3")
        cache.set(value: 4, forKey: "4")
        cache.set(value: 5, forKey: "5")
        cache.set(value: 6, forKey: "6")
        
        cache.remove(forKey: "5")
        
        XCTAssert(cache.count == 5)
        XCTAssertFalse(cache.contains("5"))
    }
    
    
    func testRemoveAll() {
        let cache = LruCache<String, Int>()
        
        cache.set(value: 1, forKey: "1")
        cache.set(value: 2, forKey: "2")
        cache.set(value: 3, forKey: "3")
        cache.removeAll()
        XCTAssert(cache.count == 0)
    }
    
    func testRemoveObjectAndRelease() {
        let cache = LruCache<Int, O>()
        
        func setO(_ key: Int) {
            cache.set(value: O(key), forKey: key)
        }
        
        setO(1)
        setO(2)
        setO(3)
        setO(4)
        setO(5)
        setO(6)
        
        XCTAssert(cache.count == 6)
        
        deinitCount = 0
        cache.remove(forKey: 3)
        XCTAssert(deinitCount == 1)
        
        XCTAssert(cache.count == 5)
        
        deinitCount = 0
        cache.trim(toCount: 2)
        XCTAssert(deinitCount == 3)
        XCTAssert(cache.count == 2)
    }
    
    func testRemoveAllAndRelease() {
        let cache = LruCache<Int, O>()
        
        func setO(_ key: Int) {
            cache.set(value: O(key), forKey: key)
        }
        
        setO(1)
        setO(2)
        setO(3)
        setO(4)
        setO(5)
        setO(6)
        
        XCTAssert(cache.count == 6)
        deinitCount = 0
        cache.removeAll()
        XCTAssert(deinitCount == 6)
        XCTAssert(cache.count == 0)
    }
    
    
    func testTrimCost() {
        let cache = LruCache<Int, O>()
        
        func setO(_ key: Int) {
            cache.set(value: O(key), forKey: key, withCost: key)
        }
        
        setO(1)
        setO(2)
        setO(3)
        setO(4)
        setO(5)
        setO(6)
        XCTAssert(cache.count == 6)
        
        deinitCount = 0
        cache.trim(toCost: 20)
        XCTAssert(deinitCount == 1)
        XCTAssert(cache.count == 5)
        
        deinitCount = 0
        cache.trim(toCost: 12)
        XCTAssert(deinitCount == 3)
        XCTAssert(cache.count == 2)
        
        deinitCount = 0
        cache.trim(toCost: 11)
        XCTAssert(deinitCount == 0)
        XCTAssert(cache.count == 2)
        
        deinitCount = 0
        cache.trim(toCost: 10)
        XCTAssert(cache.contains(6))
        XCTAssert(deinitCount == 1)
        XCTAssert(cache.count == 1)
        
        deinitCount = 0
        cache.trim(toCost: 1)
        XCTAssert(deinitCount == 1)
        XCTAssert(cache.count == 0)
    }
}
