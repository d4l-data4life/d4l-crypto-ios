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

class Data4LifeCryptoProtocolTests: XCTestCase {
    var bundle: Foundation.Bundle! = Bundle.current

    func testAsymmetricDecrypt() {
        do {
            let testModel: AsymCryptoTestModel = try bundle.decodable(fromJSON: "asymDecrypt")
            let decryptedData = try Data4LifeCryptor.asymDecrypt(key: testModel.keypair, data: testModel.inputData)
            XCTAssertEqual(testModel.outputData, decryptedData)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testAsymmetricEncrypt() {
        do {
            let testModel: AsymCryptoTestModel = try bundle.decodable(fromJSON: "asymEncrypt")
            let encryptedData = try Data4LifeCryptor.asymEncrypt(key: testModel.keypair, data: testModel.inputData)
            let decryptedData = try Data4LifeCryptor.asymDecrypt(key: testModel.keypair, data: encryptedData)
            XCTAssertEqual(testModel.inputData, decryptedData)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testSymmetricEncrypt() {
        do {
            let testModel: SymCryptoTestModel = try bundle.decodable(fromJSON: "symCommonEncrypt")
            let encryptedData = try Data4LifeCryptor.symEncrypt(key: testModel.key, data: testModel.inputData, iv: testModel.iv)
            XCTAssertEqual(testModel.outputData, encryptedData)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testSymmetricDecrypt() {
        do {
            let testModel: SymCryptoTestModel = try bundle.decodable(fromJSON: "symCommonDecrypt")
            let decryptedData = try Data4LifeCryptor.symDecrypt(key: testModel.key, data: testModel.inputData, iv: testModel.iv)
            XCTAssertEqual(testModel.outputData, decryptedData)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testEncryptTags() {
        do {
            let testModel: SymCryptoTestModel = try bundle.decodable(fromJSON: "symTagEncrypt")
            let blankIV = [UInt8](repeating: 0x00, count: testModel.key.defaultIvSize).asData
            let ciphertext = try Data4LifeCryptor.symEncrypt(key: testModel.key,
                                                            data: testModel.inputString.data(using: .utf8)!,
                                                            iv: blankIV)
            XCTAssertEqual(testModel.outputString, ciphertext.base64EncodedString())
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDecryptTags() {
        do {
            let testModel: SymCryptoTestModel = try bundle.decodable(fromJSON: "symTagDecrypt")
            let blankIV = [UInt8](repeating: 0x00, count: testModel.key.defaultIvSize).asData
            let plaintext = try Data4LifeCryptor.symDecrypt(key: testModel.key, data: testModel.inputData, iv: blankIV)
            XCTAssertEqual(testModel.outputString, String(data: plaintext, encoding: .utf8)!)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
