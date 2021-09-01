// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

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
            url: "https://d4l-ios-artifact-repository.s3.eu-central-1.amazonaws.com/d4l-data4life/d4l-crypto-ios/Data4LifeCrypto-xcframework-1.7.0.zip",
            checksum: "b0e9d6ed4a01dfbd887f47080e741c0614f2449e084288a4c557b3e8cddd6d8f"
        ),
        .testTarget(name: "Data4LifeCryptoTests",
                    dependencies: ["Data4LifeCrypto"],
                    path: "Crypto/Tests",
                    exclude: ["Info.plist", "Data4LifeCryptoHostApp.xctestplan"],
                    resources: [.process("JSON Payloads")]),
    ]
)
