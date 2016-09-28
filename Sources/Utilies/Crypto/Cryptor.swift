//
//  Cryptor.swift
//  Rubick
//
//  Created by WuFan on 16/9/27.
//
//

import Foundation

struct Cryptor {
    enum Algorithm {
        case aes
        case des
        case blowfish
    }
    
    enum Mode {
        case CBC
        case ECB
    }
    
    enum Padding {
        case none
        case pkcs7
    }
    
    let algorithm: Algorithm
    let mode: Mode
    let padding: Padding
    let iv: [UInt8]
    
    init(algorithm: Algorithm, mode: Mode, padding: Padding, iv: [UInt8]) {
        self.algorithm = algorithm
        self.mode = mode
        self.padding = padding
        self.iv = iv
    }
    
    
    
    
}

