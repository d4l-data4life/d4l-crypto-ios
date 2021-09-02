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
import CommonCrypto

public struct Data4LifeSigner: SignerProtocol {

    public static func sign(data: Data, privateKey: AsymmetricKey, salt: SigningSalt) throws -> Data {
        switch salt {
        case .unsalted:
            #warning("TODO")
            fatalError("Not implemented yet")
        case .salted:
            var error: Unmanaged<CFError>?
            let signedMessage = SecKeyCreateSignature(privateKey.value,
                                                      .rsaSignatureMessagePSSSHA256,
                                                      data as CFData,
                                                      &error) as Data?

            if let _ = error?.takeRetainedValue() {
                throw Data4LifeCryptoError.couldNotCreateSignature
            }

            guard let signedMessage = signedMessage else {
                throw Data4LifeCryptoError.couldNotCreateSignature
            }

            return signedMessage
        }
    }

    public static func verify(data: Data,
                              against signature: Data,
                              publicKey: AsymmetricKey,
                              salt: SigningSalt) throws -> Bool {

        switch salt {
        case .unsalted:
            #warning("TODO")
            fatalError("Not implemented yet")
        case .salted:
            var error: Unmanaged<CFError>?
            let isVerified = SecKeyVerifySignature(publicKey.value,
                                                   .rsaSignatureMessagePSSSHA256,
                                                   data as NSData,
                                                   signature as NSData,
                                                   &error)
            if let error = error?.takeRetainedValue() {
                throw Data4LifeCryptoError.couldNotVerifySignature
            }

            return isVerified
        }
    }
}