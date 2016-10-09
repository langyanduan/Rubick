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


struct BASE64 {
    static func encoding(data: Data) -> String {
        return ""
    }
    static func decoding(text: String) -> Data? {
        return nil
    }
}

struct URLEncoder {
    
}



func hexString(from data: Data) -> String {
    return ""
}

extension Data {
    init?(hex string: String) {
        return nil
    }
}

extension String {
    init(hex data: Data) {
        self = ""
    }
}




//func base64Encoding(data: Data) -> String {
//    return ""
//}
//
//func base64


