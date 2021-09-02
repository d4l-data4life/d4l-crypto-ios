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

public struct Data4LifeKeyGenerator: KeyGeneratorProtocol {

    public static func generateAsymKeyPair(algorithm: AlgorithmType, options: KeyOptions) throws -> KeyPair {
        guard let tag = options.tag else {
            throw Data4LifeCryptoError.missingKeyPairTagOption
        }
        return try KeyPair.generate(tag: tag, keySize: options.size, algorithm: algorithm)
    }

    public static func generateSymKey(algorithm: AlgorithmType, options: KeyOptions, type: KeyType) throws -> Key {
        return try Key.generate(keySize: options.size, algorithm: algorithm, type: type)
    }
}