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
import CryptoKit
import CommonCrypto

public struct Data4LifeCryptor: CryptorProtocol {

    public static func symEncrypt(key: Key, data: Data, iv: Data) throws -> Data {
        return try symmetricEncrypt(key: key.value, data: data, algorithm: key.algorithm, iv: iv)
    }

    public static func symDecrypt(key: Key, data: Data, iv: Data) throws -> Data {
        return try symmetricDecrypt(key: key.value, data: data, algorithm: key.algorithm, iv: iv)
    }

    public static func asymEncrypt(key: KeyPair, data: Data) throws -> Data {
        return try cipher(key: key.publicKey.value, algorithm: key.algorithm).encrypt(data)
    }

    public static func asymDecrypt(key: KeyPair, data: Data) throws -> Data {
        return try cipher(key: key.privateKey.value, algorithm: key.algorithm).decrypt(data)
    }

    public static func asymEncrypt(publicKey: AsymmetricKey, data: Data) throws -> Data {
        return try cipher(key: publicKey.value, algorithm: publicKey.algorithm).encrypt(data)
    }

    public static func asymDecrypt(privateKey: AsymmetricKey, data: Data) throws -> Data {
        return try cipher(key: privateKey.value, algorithm: privateKey.algorithm).decrypt(data)
    }
}

private extension Data4LifeCryptor {

    static func symmetricEncrypt(key: Data, data: Data, algorithm: AlgorithmType, iv: Data) throws -> Data {
        switch algorithm.type {
        case (.aes, .noPadding, .gcm?, _):
            return try encryptAesNoPaddingGcm(data: data, key: key, iv: iv)
        case (.aes, .pkcs7, .cbc?, _):
            return try encryptAesPkcs7Cbc(data: data, key: key, iv: iv)
        default:
            throw Data4LifeCryptoError.unsupportedAlgorithmCombination
        }
    }

    static func symmetricDecrypt(key: Data, data: Data, algorithm: AlgorithmType, iv: Data) throws -> Data {
        switch algorithm.type {
        case (.aes, .noPadding, .gcm?, _):
            return try decryptAesNoPaddingGcm(data: data, key: key, iv: iv)
        case (.aes, .pkcs7, .cbc?, _):
            return try decryptAesPkcs7Cbc(data: data, key: key, iv: iv)
        default:
            throw Data4LifeCryptoError.unsupportedAlgorithmCombination
        }
    }

    static func cipher(key: SecKey, algorithm: AlgorithmType) throws -> RSACipher {
        switch algorithm.type {
        case (.rsa, .oaep, _, .sha256?):
            return RSACipher(key: key, algorithm: SecKeyAlgorithm.rsaEncryptionOAEPSHA256)
        default:
            throw Data4LifeCryptoError.unsupportedAlgorithmCombination
        }
    }
}

// MARK: - AES No Padding GCM
private extension Data4LifeCryptor {

    private static let cryptoKitAESTagLength = 16

    static func encryptAesNoPaddingGcm(data: Data, key: Data, iv: Data) throws -> Data {
        let nonce = try AES.GCM.Nonce(data: iv)
        let symmetricKey = SymmetricKey(data: key)
        let sealedBox = try AES.GCM.seal(data, using: symmetricKey, nonce: nonce)
        return Data(sealedBox.ciphertext.asBytes + sealedBox.tag.asBytes)
    }

    static func decryptAesNoPaddingGcm(data: Data, key: Data, iv: Data) throws -> Data {
        let nonce = try AES.GCM.Nonce(data: iv)
        let tag = data.asBytes.suffix(Data4LifeCryptor.cryptoKitAESTagLength)
        let cipherText = data.asBytes.prefix(upTo: data.byteCount - Data4LifeCryptor.cryptoKitAESTagLength)
        let symmetricKey = SymmetricKey(data: key)
        let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: cipherText, tag: tag)
        let plainBody = try AES.GCM.open(sealedBox, using: symmetricKey)
        return plainBody
    }
}

// MARK: - AES PKCS7 CBC
private extension Data4LifeCryptor {

    static func encryptAesPkcs7Cbc(data: Data, key: Data, iv: Data) throws -> Data {
        guard let ciphertext = crypt(operation: kCCEncrypt,
                                     algorithm: kCCAlgorithmAES,
                                     options: kCCOptionPKCS7Padding,
                                     key: key,
                                     iv: iv,
                                     data: data) else {
            throw Data4LifeCryptoError.couldNotEncryptData
        }
        return ciphertext
    }

    static func decryptAesPkcs7Cbc(data: Data, key: Data, iv: Data) throws -> Data {
        guard let decryptedData = crypt(operation: kCCDecrypt,
                                        algorithm: kCCAlgorithmAES,
                                        options: kCCOptionPKCS7Padding,
                                        key: key,
                                        iv: iv,
                                        data: data) else {
            throw Data4LifeCryptoError.couldNotDecryptData
        }

        return decryptedData
    }
}

// MARK: - CommonCrypto helper
private extension Data4LifeCryptor {
    static func crypt(operation: Int, algorithm: Int, options: Int, key: Data, iv: Data, data: Data) -> Data? {
        return key.withUnsafeBytes { keyUnsafeRawBufferPointer in
            return data.withUnsafeBytes { dataInUnsafeRawBufferPointer in
                return iv.withUnsafeBytes { ivUnsafeRawBufferPointer in

                    var padding: Int = 0
                    if (options & kCCOptionPKCS7Padding != 0) {
                        padding = kCCBlockSizeAES128
                    }
                    let dataOutSize: Int = data.count + iv.count + padding
                    let dataOut = UnsafeMutableRawPointer.allocate(byteCount: dataOutSize,
                                                                   alignment: 1)
                    defer { dataOut.deallocate() }
                    var dataOutMoved: Int = 0
                    let status = CCCrypt(CCOperation(operation), CCAlgorithm(algorithm),
                                         CCOptions(options),
                                         keyUnsafeRawBufferPointer.baseAddress, key.count,
                                         ivUnsafeRawBufferPointer.baseAddress,
                                         dataInUnsafeRawBufferPointer.baseAddress, data.count,
                                         dataOut, dataOutSize, &dataOutMoved)
                    guard status == kCCSuccess else { return nil }
                    return Data(bytes: dataOut, count: dataOutMoved)
                }
            }
        }
    }
}
