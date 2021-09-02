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
//

import Foundation

public protocol CryptorProtocol {
    static func symEncrypt(key: Key, data: Data, iv: Data) throws -> Data
    static func symDecrypt(key: Key, data: Data, iv: Data) throws -> Data
    static func asymEncrypt(key: KeyPair, data: Data) throws -> Data
    static func asymDecrypt(key: KeyPair, data: Data) throws -> Data
}

public protocol SignerProtocol {
    static func sign(data: Data, privateKey: AsymmetricKey, salt: SigningSalt) throws -> Data
    static func verify(data: Data, against signature: Data, publicKey: AsymmetricKey, salt: SigningSalt) throws -> Bool
}

public protocol KeyGeneratorProtocol {
    static func generateAsymKeyPair(algorithm: AlgorithmType, options: KeyOptions) throws -> KeyPair
    static func generateSymKey(algorithm: AlgorithmType, options: KeyOptions, type: KeyType) throws -> Key
}
