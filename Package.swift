// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let cryptoVersion = "1.5.1"

let package = Package(
    name: "Data4LifeCrypto",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "Data4LifeCrypto",
            targets: ["Data4LifeCrypto"]),
    ],
    targets: [
        .binaryTarget(
            name: "Data4LifeCrypto",
            url: "https://github.com/d4l-data4life/d4l-sdk-ios/releases/download/\(cryptoVersion)/Data4LifeCrypto-xcframework-\(cryptoVersion).zip",
            checksum: "c4724e0af0c0dda1c4b4902f541163d1e8ee1540e106a2a6d95ee4bb4463198d"
        ),
        .testTarget(name: "Data4LifeCryptoTests",
                    dependencies: ["Data4LifeCrypto"],
                    path: "Crypto/Tests",
                    exclude: ["Info.plist"],
                    resources: [.process("JSON Payloads")]),
    ]
)
