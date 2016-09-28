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
    func generateBytes(_ count: Int) -> [UInt8] {
        var bytes = [UInt8](repeating: 0, count: count)
        CCRandomGenerateBytes(&bytes, count)
        return bytes
    }
}

