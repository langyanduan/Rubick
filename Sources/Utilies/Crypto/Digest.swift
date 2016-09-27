//
//  Digest.swift
//  Rubick
//
//  Created by WuFan on 16/9/27.
//
//

import Foundation
import CommonCrypto

struct Digest: Updatable {
    enum Algorithm {
        case md2
        case md4
        case md5
        case sha1
        case sha224
        case sha256
        case sha384
        case sha512
        
        var digestLength: Int {
            switch self {
            case .md2:
                return Int(CC_MD2_DIGEST_LENGTH)
            case .md4:
                return Int(CC_MD4_DIGEST_LENGTH)
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
    }
    
//    let engine: DigestEngine
    init(algorithm: Algorithm) {
        
//        switch algorithm {
//        case .md2:
//            engine = DigestEngineCC<CC_MD2_CTX>(initializer:CC_MD2_Init, updater:CC_MD2_Update, finalizer:CC_MD2_Final, length:CC_MD2_DIGEST_LENGTH)
//        case .md4:
//            engine = DigestEngineCC<CC_MD4_CTX>(initializer:CC_MD4_Init, updater:CC_MD4_Update, finalizer:CC_MD4_Final, length:CC_MD4_DIGEST_LENGTH)
//        case .md5:
//            engine = DigestEngineCC<CC_MD5_CTX>(initializer:CC_MD5_Init, updater:CC_MD5_Update, finalizer:CC_MD5_Final, length:CC_MD5_DIGEST_LENGTH)
//        case .sha1:
//            engine = DigestEngineCC<CC_SHA1_CTX>(initializer:CC_SHA1_Init, updater:CC_SHA1_Update, finalizer:CC_SHA1_Final, length:CC_SHA1_DIGEST_LENGTH)
//        case .sha224:
//            engine = DigestEngineCC<CC_SHA256_CTX>(initializer:CC_SHA224_Init, updater:CC_SHA224_Update, finalizer:CC_SHA224_Final, length:CC_SHA224_DIGEST_LENGTH)
//        case .sha256:
//            engine = DigestEngineCC<CC_SHA256_CTX>(initializer:CC_SHA256_Init, updater:CC_SHA256_Update, finalizer:CC_SHA256_Final, length:CC_SHA256_DIGEST_LENGTH)
//        case .sha384:
//            engine = DigestEngineCC<CC_SHA512_CTX>(initializer:CC_SHA384_Init, updater:CC_SHA384_Update, finalizer:CC_SHA384_Final, length:CC_SHA384_DIGEST_LENGTH)
//        case .sha512:
//            engine = DigestEngineCC<CC_SHA512_CTX>(initializer:CC_SHA512_Init, updater:CC_SHA512_Update, finalizer:CC_SHA512_Final, length:CC_SHA512_DIGEST_LENGTH)
//        }
    }
    
    @discardableResult
    func update(fromBytes bytes: UnsafeRawPointer, count: Int) -> Digest {
        
        return self
    }
    
    func final() -> [UInt8] {
        return []
    }
}
