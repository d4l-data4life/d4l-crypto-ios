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

class Data4LifeKeySignerTests: XCTestCase {

    private let bundle = Foundation.Bundle.current

    func testSignAndVerifyWithSalted() throws {

        // Given
        let keyPair: KeyPair = try bundle.decodable(fromJSON: "asymDonationServiceKey")
        let data = "Hello World!".data(using: .utf8)!

        // When
        let signature = try Data4LifeSigner.sign(data: data,
                                                  privateKey: keyPair.privateKey,
                                                  isSalted: true)

        let isVerified = try Data4LifeSigner.verify(data: data,
                                                    against: signature,
                                                    publicKey: keyPair.publicKey,
                                                    isSalted: true)
        XCTAssertEqual(isVerified, true)
    }

    func testSignAndVerifyWithUnsalted() throws {

        // Given
        let keyPair: KeyPair = try bundle.decodable(fromJSON: "asymDonationServiceKey")
        let data = "Hello World!".data(using: .utf8)!

        // When
        let signature = try Data4LifeSigner.sign(data: data,
                                                 privateKey: keyPair.privateKey,
                                                 isSalted: false)

        let isVerified = try Data4LifeSigner.verify(data: data,
                                                    against: signature,
                                                    publicKey: keyPair.publicKey,
                                                    isSalted: false)
        XCTAssertEqual(isVerified, true)
    }

    func testVerifySalted() throws {

        // Given
        let keyPair: KeyPair = try bundle.decodable(fromJSON: "asymDonationServiceKey")
        let data = "Hello World!".data(using: .utf8)!
        let signatureString = String(data: bundle.data(forResource: "ExampleSignature32", withExtension: "txt")!, encoding: .utf8)!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let signature = Data(base64Encoded: signatureString)!

        // When
        let isVerified = try Data4LifeSigner.verify(data: data,
                                                    against: signature,
                                                    publicKey: keyPair.publicKey,
                                                    isSalted: true)

        // Then
        XCTAssertEqual(isVerified, true)
    }

    func testVerifyUnsalted() throws {

        // Given
        let keyPair: KeyPair = try bundle.decodable(fromJSON: "asymDonationServiceKey")
        let data = "Hello World!".data(using: .utf8)!
        let signatureString = String(data: bundle.data(forResource: "ExampleSignature0", withExtension: "txt")!, encoding: .utf8)!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let signature = Data(base64Encoded: signatureString)!

        // When
        let isVerified = try Data4LifeSigner.verify(data: data,
                                                    against: signature,
                                                    publicKey: keyPair.publicKey,
                                                    isSalted: false)

        // Then
        XCTAssertEqual(isVerified, true)
    }
}
