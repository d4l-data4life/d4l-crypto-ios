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
@_implementationOnly import Data4LifeCryptoRSAPSS

public struct Data4LifeSigner: SignerProtocol {

    public static func sign(data: Data, privateKey: AsymmetricKey, isSalted: Bool) throws -> Data {
        do {
            return try D4L.RSAPSS.sign(data: data,
                                       privateKey: privateKey.value,
                                       saltType: isSalted ? .salted : .unsalted)
        } catch {
            throw Data4LifeCryptoError.couldNotCreateSignature
        }
    }

    public static func verify(data: Data,
                              against signature: Data,
                              publicKey: AsymmetricKey,
                              isSalted: Bool) throws -> Bool {

        do {
            return try D4L.RSAPSS.verify(data: data,
                                         against: signature,
                                         publicKey: publicKey.value,
                                         saltType: isSalted ? .salted : .unsalted)
        } catch {
            throw Data4LifeCryptoError.couldNotVerifySignature
        }
    }
}
