//
//  HMAC.swift
//  Rubick
//
//  Created by WuFan on 16/9/27.
//
//

import Foundation
import CommonCrypto

public class HMAC: Updatable {
    enum Algorithm {
        case md5
        case sha1
        case sha224
        case sha256
        case sha384
        case sha512
        
        var digestLength: Int {
            switch self {
            case .md5:
                return Int(CC_MD5_DIGEST_LENGTH)
            case .sha1:
                return Int(CC_SHA1_DIGEST_LENGTH)
            case .sha224:
                return Int(CC_SHA224_DIGEST_LENGTH)
            case .sha256:
                return Int(CC_SHA256_DIGEST_LENGTH)
            case .sha384:
                return Int(CC_SHA384_DIGEST_LENGTH)
            case .sha512:
                return Int(CC_SHA512_DIGEST_LENGTH)
            }
        }
        
        fileprivate var nativeValue: Int {
            switch self {
            case .md5:
                return kCCHmacAlgMD5
            case .sha1:
                return kCCHmacAlgSHA1
            case .sha224:
                return kCCHmacAlgSHA224
            case .sha256:
                return kCCHmacAlgSHA256
            case .sha384:
                return kCCHmacAlgSHA384
            case .sha512:
                return kCCHmacAlgSHA512
            }
        }
    }
    
    
    let algorithm: Algorithm
    let context = UnsafeMutablePointer<CCHmacContext>.allocate(capacity: 1)
    
    init(algorithm: Algorithm, key: [UInt8]) {
        CCHmacInit(context, UInt32(algorithm.nativeValue), UnsafeRawPointer(key), key.count)
        self.algorithm = algorithm
    }
    
    deinit {
        context.deallocate(capacity: 1)
    }
    
    public func update(fromBytes bytes: UnsafeRawPointer, count: Int) -> Self {
        CCHmacUpdate(context, bytes, count)
        return self
    }
    
    public func final() -> [UInt8] {
        var hmac = [UInt8](repeating: 0, count: algorithm.digestLength)
        CCHmacFinal(context, &hmac)
        return hmac
    }
}
