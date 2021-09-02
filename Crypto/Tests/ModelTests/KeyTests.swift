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

class KeyTests: XCTestCase {

    func testInitializeKeyWithDataWithCorrectSize() throws {
        let keyData = "this is a key and you don't know".data(using: .utf8)!
        let key = try Key(data: keyData, type: .common)
        XCTAssertEqual(key.keySize, 256)
        XCTAssertEqual(key.type, .common)
        XCTAssertEqual(key.value, keyData)
        XCTAssertEqual(key.algorithm as? AESAlgorithm, AESAlgorithm.noPaddingGCM())
    }

    func testInitializeKeyWithDataWithFalseSize() throws {
        let keyData = "this is a key with wrong size".data(using: .utf8)!
        XCTAssertThrowsError(try Key(data: keyData, type: .common), "should throw error", { error in
            XCTAssertEqual(error as? Data4LifeCryptoError, Data4LifeCryptoError.keyDoesNotMatchExpectedSize)
        })
    }

    func testGenerateKeyWithAlgorithms() throws {
        let key = try Key.generate(keySize: 256, algorithm: AESAlgorithm.noPaddingGCM(), type: .common)
        XCTAssertEqual(key.keySize, 256)
        XCTAssertEqual(key.type, .common)
        XCTAssertEqual(key.algorithm as? AESAlgorithm, AESAlgorithm.noPaddingGCM())
        XCTAssertNotNil(key.value)
        XCTAssertEqual(key.value.byteCount, 32)
    }
}
