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

public struct Base64Coder {
    public static func encoding(data: Data) -> String {
        return ""
    }
    public static func decoding(text: String) -> Data? {
        return nil
    }
}

public struct URLCoder {
    
}

public struct HexCoder {
    public static func encoding(data: Data) -> String {
        return data.reduce("") { $0 + String(format: "%02x", $1) }
    }
    
    public static func decoding(text: String) -> Data? {
        return nil
    }
}
