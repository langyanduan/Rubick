//
//  ValidatorTests.swift
//  Rubick
//
//  Created by WuFan on 2016/9/29.
//
//

import XCTest
import Rubick

class ValidatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testChinese() {
        XCTAssert("依然范特西".ext.isChinese)
        XCTAssert("中国".ext.isChinese)
        XCTAssert("天气不错".ext.isChinese)
        XCTAssert("左手一个慢动作".ext.isChinese)
        XCTAssert("好".ext.isChinese)
        
        XCTAssertFalse("1".ext.isChinese)
        XCTAssertFalse("12345".ext.isChinese)
        XCTAssertFalse("abcde".ext.isChinese)
        XCTAssertFalse("1a".ext.isChinese)
        XCTAssertFalse("昨天a".ext.isChinese)
        XCTAssertFalse("今天1".ext.isChinese)
        XCTAssertFalse("1明天a".ext.isChinese)
    }
    
    func testNumber() {
        XCTAssert("12345".ext.isNumber)
        XCTAssert("1".ext.isNumber)
        XCTAssert("0000".ext.isNumber)
        XCTAssert("2905".ext.isNumber)
        
        XCTAssertFalse("".ext.isNumber)
        XCTAssertFalse("-".ext.isNumber)
        XCTAssertFalse("a".ext.isNumber)
        XCTAssertFalse("1a".ext.isNumber)
        XCTAssertFalse("112a4".ext.isNumber)
        XCTAssertFalse("%1124".ext.isNumber)
        XCTAssertFalse("112_4".ext.isNumber)
        XCTAssertFalse("1.124".ext.isNumber)
    }
    
    func testPhoneNumber() {
        XCTAssert("18268160990".ext.isPhoneNumber)
        XCTAssert("15267088277".ext.isPhoneNumber)
        XCTAssert("15158059278".ext.isPhoneNumber)
        XCTAssert("13867857288".ext.isPhoneNumber)
        XCTAssert("14755559999".ext.isPhoneNumber)
        XCTAssert("13777056988".ext.isPhoneNumber)
        XCTAssert("17038195737".ext.isPhoneNumber)
        
        XCTAssertFalse("1377.056988".ext.isPhoneNumber)
        XCTAssertFalse("111111111".ext.isPhoneNumber)
        XCTAssertFalse("11111111111".ext.isPhoneNumber)
        XCTAssertFalse("111111111111".ext.isPhoneNumber)
        XCTAssertFalse("113777056988".ext.isPhoneNumber)
        XCTAssertFalse("aaa".ext.isPhoneNumber)
        XCTAssertFalse("190129029".ext.isPhoneNumber)
        XCTAssertFalse("113777056988".ext.isPhoneNumber)
        XCTAssertFalse("113777056988".ext.isPhoneNumber)
    }
    
    func testEmail() {
        XCTAssert("1@2.cn".ext.isEmail)
        XCTAssert("hahah@aa.com".ext.isEmail)
        XCTAssert("hahah@163.com".ext.isEmail)
        XCTAssert("120@aa.com.cn".ext.isEmail)
        XCTAssert("12@aa.com".ext.isEmail)
        XCTAssert("a.b.c@aa.com".ext.isEmail)
        XCTAssert("__ass@aa.com".ext.isEmail)
        XCTAssert("a+ss@aa.com".ext.isEmail)
        XCTAssert("a-ss@aa.com".ext.isEmail)
        XCTAssert("a%%@aa.com".ext.isEmail)
        
        XCTAssertFalse("a%%aa.com".ext.isEmail)
        XCTAssertFalse("a.com".ext.isEmail)
        XCTAssertFalse("123123.com".ext.isEmail)
        XCTAssertFalse("ok@aa".ext.isEmail)
    }
    
    func testLetter() {
        XCTAssert("abcdefg".ext.isLetter)
        XCTAssert("zxv".ext.isLetter)
        XCTAssert("sdfasdf".ext.isLetter)
        XCTAssert("a".ext.isLetter)
        
        XCTAssertFalse("".ext.isLetter)
        XCTAssertFalse(".".ext.isLetter)
        XCTAssertFalse("$".ext.isLetter)
        XCTAssertFalse("1".ext.isLetter)
        XCTAssertFalse("abcd1".ext.isLetter)
        XCTAssertFalse("1293112".ext.isLetter)
    }
    
    func testURL() {
        XCTAssert("http://ooo.0o0.ooo".ext.isURL)
        XCTAssert("http://ooo.0o0.ooo/".ext.isURL)
        XCTAssert("http://t.tt".ext.isURL)
        XCTAssert("http://mi.com".ext.isURL)
        XCTAssert("http://360.com".ext.isURL)
        XCTAssert("https://www.baidu.com".ext.isURL)
        XCTAssert("https://baidu.com".ext.isURL)
        XCTAssert("http://zj.tiaohaowang.com/ydxuanhao/?dis=3&zifei=269&haoduan=147".ext.isURL)
        XCTAssert("http://10.12.8.250:8080/tfs/DacaiV5Collection_Git/_git/Dacai.iOSpath=Kathmandu%2FKathmanduAssistants%2FKTMValidator.m&version=GBdisable_315&_a=contents".ext.isURL)
        
        XCTAssertFalse("ssh://qq.com".ext.isURL)
        XCTAssertFalse("http://abc".ext.isURL)
        XCTAssertFalse("http://qwer.123".ext.isURL)
        XCTAssertFalse("http://ab%20%%%c.com".ext.isURL)
        XCTAssertFalse("http://abc".ext.isURL)
        
    }
    
    func testIdentifier() {
        
    }
}

