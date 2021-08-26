// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let cryptoVersion = "v1.6.0"

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
            url: "https://github.com/d4l-data4life/d4l-crypto-ios/releases/download/\(cryptoVersion)/Data4LifeCrypto-xcframework-\(cryptoVersion).zip",
            checksum: "fc6a972fd1434a6f48b6b1a905cb3c4a66af19b797125dbdddfbd253e54e8360"
        ),
        .testTarget(name: "Data4LifeCryptoTests",
                    dependencies: ["Data4LifeCrypto"],
                    path: "Crypto/Tests",
                    exclude: ["Info.plist", "Data4LifeCryptoHostApp.xctestplan"],
                    resources: [.process("JSON Payloads")]),
    ]
)
