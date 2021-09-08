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

class AsymmetricKeyTests: XCTestCase {

    private let bundle = Foundation.Bundle.current

    func testInitializeAsymmetricPrivateKeyWithDataWithSuccess() throws {

        // Given
        let size = 2048
        let filename = "asymPrivateExchangeKeyPKCS8"
        let keypair: KeyPair = try bundle.decodable(fromJSON: filename)
        let asymmetricKeyData = try keypair.privateKey.asData()

        // When
        let asymmetricKey = try AsymmetricKey(data: asymmetricKeyData, type: .private, keySize: size)

        // Then
        XCTAssertNotNil(asymmetricKey)
        XCTAssertEqual(try asymmetricKey.asBase64EncodedString(),
                       try keypair.privateKey.asBase64EncodedString())

    }

    func testInitializeAsymmetricPublicKeyWithDataWithSuccess() throws {

        // Given
        let size = 2048
        let filename = "asymPrivateExchangeKeyPKCS8"
        let keypair: KeyPair = try bundle.decodable(fromJSON: filename)
        let asymmetricKeyData = try keypair.publicKey.asData()

        // When
        let asymmetricKey = try AsymmetricKey(data: asymmetricKeyData, type: .public, keySize: size)

        // Then
        XCTAssertNotNil(asymmetricKey)
        XCTAssertEqual(try asymmetricKey.asBase64EncodedString(),
                       try keypair.publicKey.asBase64EncodedString())

    }

    func testInitializeAsymmetricKeyWithDataWithTypeMismatch() throws {

        // Given
        let size = 2048
        let filename = "asymPrivateExchangeKeyPKCS8"
        let keypair: KeyPair = try bundle.decodable(fromJSON: filename)
        let asymmetricKeyData = try keypair.privateKey.asData()

        // Then
        XCTAssertThrowsError(try AsymmetricKey(data: asymmetricKeyData, type: .public, keySize: size))
    }
}
