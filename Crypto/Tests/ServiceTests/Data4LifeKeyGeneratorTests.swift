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

import XCTest
import Data4LifeCrypto
import Foundation

class Data4LifeKeyGeneratorTests: XCTestCase {

    func testGenerateKey() {
        do {
            let keyExchange = try! KeyExchangeFactory.create(type: .data)
            let options = KeyOptions(size: keyExchange.size)
            let key = try Data4LifeKeyGenerator.generateSymKey(algorithm: keyExchange.algorithm, options: options, type: .data)
            XCTAssertEqual(key.algorithm.blockMode, BlockMode.gcm)
            XCTAssertEqual(key.algorithm.cipher, CipherType.aes)
            XCTAssertEqual(key.algorithm.padding, Padding.noPadding)
            XCTAssertEqual(key.algorithm.hash, nil)
            XCTAssertEqual(key.keySize, 256)
            XCTAssertEqual(key.type, .data)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    #if SWIFT_PACKAGE
    #else
    func testGenerateKeyPair() {
        do {
            let keyExchange = try! KeyExchangeFactory.create(type: .appPrivate)
            let options = KeyOptions(size: keyExchange.size, tag: UUID().uuidString)
            let keyPair = try Data4LifeKeyGenerator.generateAsymKeyPair(algorithm: keyExchange.algorithm, options: options)
            XCTAssertEqual(keyPair.algorithm.blockMode, nil)
            XCTAssertEqual(keyPair.algorithm.cipher, CipherType.rsa)
            XCTAssertEqual(keyPair.algorithm.padding, Padding.oaep)
            XCTAssertEqual(keyPair.algorithm.hash, HashType.sha256)
            XCTAssertEqual(keyPair.keySize, 2048)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    #endif
}
