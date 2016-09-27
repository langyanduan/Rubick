//
//  Crypto.swift
//  Rubick
//
//  Created by WuFan on 2016/9/27.
//
//

import Foundation
import CommonCrypto

enum CryptoInput {
    case data(Data)
    case stream(InputStream)
}
