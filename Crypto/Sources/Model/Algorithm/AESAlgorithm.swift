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

public struct AESAlgorithm: AlgorithmType, Equatable {
    public let cipher: CipherType
    public let padding: Padding
    public let blockMode: BlockMode?
    public let hash: HashType?

    init(cipher: CipherType, padding: Padding, blockMode: BlockMode, hash: HashType?) {
        self.cipher = cipher
        self.padding = padding
        self.blockMode = blockMode
        self.hash = hash
    }
}

public extension AESAlgorithm {
    static func noPaddingGCM(hash: HashType? = nil) -> AESAlgorithm {
        AESAlgorithm(cipher: .aes, padding: .noPadding, blockMode: .gcm, hash: hash)
    }

    static func pkcs7CBC(hash: HashType? = nil) -> AESAlgorithm {
        AESAlgorithm(cipher: .aes, padding: .pkcs7, blockMode: .cbc, hash: hash)
    }
}
