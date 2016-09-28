//
//  Digest.swift
//  Rubick
//
//  Created by WuFan on 16/9/27.
//
//

import Foundation
import CommonCrypto

public class Digest: Updatable {
    public enum Algorithm {
        case md2
        case md4
        case md5
        case sha1
        case sha224
        case sha256
        case sha384
        case sha512
        
        public var digestLength: Int {
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
    
    private let engine: DigestEngine
    public let algorithm: Algorithm
    
    public init(algorithm: Algorithm) {
        self.algorithm = algorithm
        
        switch algorithm {
        case .md2:
            engine = DigestEngineCC(initializer:CC_MD2_Init, updater:CC_MD2_Update, finalizer:CC_MD2_Final, digestLength:algorithm.digestLength)
        case .md4:
            engine = DigestEngineCC(initializer:CC_MD4_Init, updater:CC_MD4_Update, finalizer:CC_MD4_Final, digestLength:algorithm.digestLength)
        case .md5:
            engine = DigestEngineCC(initializer:CC_MD5_Init, updater:CC_MD5_Update, finalizer:CC_MD5_Final, digestLength:algorithm.digestLength)
        case .sha1:
            engine = DigestEngineCC(initializer:CC_SHA1_Init, updater:CC_SHA1_Update, finalizer:CC_SHA1_Final, digestLength:algorithm.digestLength)
        case .sha224:
            engine = DigestEngineCC(initializer:CC_SHA224_Init, updater:CC_SHA224_Update, finalizer:CC_SHA224_Final, digestLength:algorithm.digestLength)
        case .sha256:
            engine = DigestEngineCC(initializer:CC_SHA256_Init, updater:CC_SHA256_Update, finalizer:CC_SHA256_Final, digestLength:algorithm.digestLength)
        case .sha384:
            engine = DigestEngineCC(initializer:CC_SHA384_Init, updater:CC_SHA384_Update, finalizer:CC_SHA384_Final, digestLength:algorithm.digestLength)
        case .sha512:
            engine = DigestEngineCC(initializer:CC_SHA512_Init, updater:CC_SHA512_Update, finalizer:CC_SHA512_Final, digestLength:algorithm.digestLength)
        }
    }
    
    @discardableResult
    public func update(fromBytes bytes: UnsafeRawPointer, count: Int) -> Self {
        engine.update(fromBytes: bytes, count: count)
        return self
    }
    
    public func final() -> [UInt8] {
        return engine.final()
    }
}

private protocol DigestEngine {
    func update(fromBytes bytes: UnsafeRawPointer, count: Int)
    func final() -> [UInt8]
}

private class DigestEngineCC<CTX>: DigestEngine {
    typealias Context = UnsafeMutablePointer<CTX>
    typealias Buffer = UnsafeRawPointer
    typealias Digest = UnsafeMutablePointer<UInt8>
    
    typealias Initializer = (Context) -> Int32
    typealias Updater = (Context, Buffer, CC_LONG) -> Int32
    typealias Finalizer = (Digest, Context) -> Int32
    
    let context: Context = Context.allocate(capacity: 1)
    let initializer: Initializer
    let updater: Updater
    let finalizer: Finalizer
    let digestLength: Int
    
    init(initializer: @escaping Initializer, updater: @escaping Updater, finalizer: @escaping Finalizer, digestLength: Int) {
        self.initializer = initializer
        self.updater = updater
        self.finalizer = finalizer
        self.digestLength = digestLength
        
        _ = initializer(context)
    }
    
    deinit {
        context.deallocate(capacity: 1)
    }
    
    func update(fromBytes bytes: Buffer, count: Int) {
        _ = updater(context, bytes, CC_LONG(count))
    }
    
    func final() -> [UInt8] {
        var digest = Array<UInt8>(repeating: 0, count:digestLength)
        _ = finalizer(&digest, context)
        return digest
    }
}
