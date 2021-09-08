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

class KeyPairTests: XCTestCase {

    private let bundle = Foundation.Bundle.current

    func testGenerateKeyPairAndExportPubKeyAsSPKI() throws {

        // Given
        let tag = UUID().uuidString
        let size = 2048
        let algo = RSAAlgorithm()

        // When
        let keyPair = try KeyPair.generate(tag: tag, keySize: size, algorithm: algo, isPermanent: false)
        let key = try keyPair.publicKey.asSPKIBase64EncodedString()

        // Then
        XCTAssertNotNil(key)
    }

    func testGenerateKeyPairAndFailExportingAsSPKI() throws {

        // Given
        let tag = UUID().uuidString
        let size = 1024 // there is no SPKI header for 1024 key, but it's possible to create keypair
        let algo = RSAAlgorithm()

        // When
        let keyPair = try KeyPair.generate(tag: tag, keySize: size, algorithm: algo, isPermanent: false)

        // Then
        XCTAssertThrowsError(try keyPair.publicKey.asSPKIBase64EncodedString(), "should throw error") { error in
            XCTAssertEqual(error as? Data4LifeCryptoError, .missingHeaderBytesForKeySize(1024))
        }
    }

    func testGenerateKeyPairWithPermanentFalse() throws {

        // Given
        let tag = UUID().uuidString
        let size = 2048
        let algo = RSAAlgorithm()

        // When
        _ = try KeyPair.generate(tag: tag, keySize: size, algorithm: algo, isPermanent: false)

        // Then
        XCTAssertThrowsError(try KeyPair.load(tag: tag, algorithm: algo), "should throw error") { error in
            XCTAssertEqual(error as? Data4LifeCryptoError, .couldNotReadKeyPair(tag))
        }
    }
}

#if SWIFT_PACKAGE
#else
extension KeyPairTests {

    func testGenerateKeyPairWithPermanentTrue() throws {

        // Given
        let tag = UUID().uuidString
        let size = 2048
        let algo = RSAAlgorithm()

        // When
        _ = try KeyPair.generate(tag: tag, keySize: size, algorithm: algo, isPermanent: true)
        let loadedKeyPair = try KeyPair.load(tag: tag, algorithm: algo)

        // Then
        XCTAssertNotNil(loadedKeyPair)
        XCTAssertNoThrow(try KeyPair.destroy(tag: tag))
    }

    func testGeneratedKeyPairAndStoredWithPermanentAreTheSame() throws {

        // Given
        let tag = UUID().uuidString
        let size = 2048
        let algo = RSAAlgorithm()

        // When
        let keyPair = try KeyPair.generate(tag: tag, keySize: size, algorithm: algo, isPermanent: true)
        let loadedKeyPair = try KeyPair.load(tag: tag, algorithm: algo)

        // Then
        XCTAssertEqual(try keyPair.privateKey.asBase64EncodedString(),
                       try loadedKeyPair.privateKey.asBase64EncodedString())
        XCTAssertEqual(try keyPair.publicKey.asBase64EncodedString(),
                       try loadedKeyPair.publicKey.asBase64EncodedString())
        XCTAssertEqual(keyPair.algorithm.blockMode?.rawValue, loadedKeyPair.algorithm.blockMode?.rawValue)
        XCTAssertEqual(keyPair.algorithm.cipher.rawValue, loadedKeyPair.algorithm.cipher.rawValue)
        XCTAssertEqual(keyPair.algorithm.padding.rawValue, loadedKeyPair.algorithm.padding.rawValue)
        XCTAssertEqual(keyPair.algorithm.hash?.rawValue, loadedKeyPair.algorithm.hash?.rawValue)
    }

    func testStoreKeyPairSuccessfully() throws {
        let keyPair: KeyPair = try bundle.decodable(fromJSON: "asymDonationKey")
        let tag = UUID().uuidString
        let algo = RSAAlgorithm()
        try keyPair.store(tag: tag)
        let fetchedKeyPair = try KeyPair.load(tag: tag, algorithm: algo)
        XCTAssertEqual(try keyPair.publicKey.asBase64EncodedString(),
                       try fetchedKeyPair.publicKey.asBase64EncodedString())
        XCTAssertEqual(try keyPair.privateKey.asBase64EncodedString(),
                       try fetchedKeyPair.privateKey.asBase64EncodedString())
        try KeyPair.destroy(tag: tag)
    }

    func testStoreKeyPairFail() throws {
        let keyPair: KeyPair = try bundle.decodable(fromJSON: "asymDonationKey")
        let tag = UUID().uuidString
        try keyPair.store(tag: tag)
        XCTAssertThrowsError(try keyPair.store(tag: tag), "should fail because it already exists") { error in
            XCTAssertEqual(error as? Data4LifeCryptoError, Data4LifeCryptoError.couldNotStoreKeyPair(tag))
        }
        try KeyPair.destroy(tag: tag)
    }
}
#endif
