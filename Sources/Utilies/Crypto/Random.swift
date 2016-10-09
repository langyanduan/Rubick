//
//  File.swift
//  Rubick
//
//  Created by WuFan on 2016/9/28.
//
//

import Foundation
import CommonCrypto

struct Random {
    static func generateBytes(byteCount count: Int) -> [UInt8] {
        var bytes = [UInt8](repeating: 0, count: count)
        CCRandomGenerateBytes(&bytes, count)
        return bytes
    }
    
    static func generateUInt8() -> UInt8 {
        return UInt8(arc4random_uniform(UInt32(UInt8.max)))
    }
    
    static func generateUInt16() -> UInt16 {
        return UInt16(arc4random_uniform(UInt32(UInt16.max)))
    }
    
    static func generateUInt32() -> UInt32 {
        return arc4random_uniform(UInt32.max)
    }
    
    static func generateUInt64() -> UInt64 {
        return UInt64(arc4random_uniform(UInt32.max)) << 32 | UInt64(arc4random_uniform(UInt32.max))
    }
}

