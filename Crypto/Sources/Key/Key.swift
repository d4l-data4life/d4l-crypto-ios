//  Copyright (c) 2021 D4L data4life gGmbH
//  All rights reserved.
//  
//  D4L owns all legal rights, title and interest in and to the Software Development Kit ("SDK"),
//  including any intellectual property rights that subsist in the SDK.
//  
//  The SDK and its documentation may be accessed and used for viewing/review purposes only.
//  Any usage of the SDK for other purposes, including usage for the development of
//  applications/third-party applications shall require the conclusion of a license agreement
//  between you and D4L.
//  
//  If you are interested in licensing the SDK for your own applications/third-party
//  applications and/or if you’d like to contribute to the development of the SDK, please
//  contact D4L by email to help@data4life.care.

import Foundation

public struct Key {
    public let value: Data
    public var algorithm: AlgorithmType
    public let keySize: KeySize
    public let type: KeyType
}

extension Key {
    public init(data: Data, type: KeyType) throws {
        let keyExchangeFormat = try KeyExhangeFactory.create(type: type)
        guard data.byteCount == keyExchangeFormat.size / 8 else {
            throw Data4LifeCryptoError.keyDoesNotMatchExpectedSize
        }
        self = Key(value: data,
                   algorithm: keyExchangeFormat.algorithm,
                   keySize: keyExchangeFormat.size,
                   type: type)
    }
}

extension Key {
    public static func generate(keySize: KeySize, algorithm: AlgorithmType, type: KeyType) throws -> Key {
        let byteCount = keySize / 8
        var randomBytes: [UInt8] = Array(repeating: 0, count: byteCount)
        let status = SecRandomCopyBytes(kSecRandomDefault, byteCount, &randomBytes)
        guard status == errSecSuccess else {
            throw Data4LifeCryptoError.couldNotCopySecureRandomBytes
        }

        return Key(value: Data(randomBytes), algorithm: algorithm, keySize: keySize, type: type)
    }
}

extension Key: Equatable {
    public static func == (lhs: Key, rhs: Key) -> Bool {
        return lhs.value.base64EncodedString() == rhs.value.base64EncodedString()
    }
}

extension Key {
    public var defaultIvSize: Int {
        switch algorithm.blockMode {
        case .cbc?:
            return 16
        case .gcm?:
            return 12
        case .none:
            return 0
        }
    }
}
