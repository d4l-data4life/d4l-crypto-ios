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
    dependencies: [
        .package(name: "Data4LifeCryptoRSAPSS",
                 url: "https://github.com/d4l-data4life/d4l-crypto-rsa-pss-ios.git",
                 .upToNextMinor(from: "1.0.0"))

    ],
    targets: [
        .target(name: "RSAPSSDependency",
                dependencies: [
                    .product(name: "Data4LifeCryptoRSAPSS",
                             package: "Data4LifeCryptoRSAPSS")
                ],
                path: "SwiftPMDependencyTarget/RSAPSS"),
        .binaryTarget(
            name: "Data4LifeCrypto",
            url: "https://d4l-ios-artifact-repository.s3.eu-central-1.amazonaws.com/d4l-data4life/d4l-crypto-ios/Data4LifeCrypto-xcframework-v1.8.0.zip",
            checksum: "2021-11-17 15:36:36.590 xcodebuild[50669:11807774] [MT] DVTPlugInManager: Required plug-in compatibility UUID 8BAA96B4-5225-471B-B124-D32A349B8106 for Kotlin.ideplugin (org.kotlinlang.xcode.kotlin) not present
2021-11-17 15:36:37.871 xcodebuild[50671:11807925] [MT] DVTPlugInManager: Required plug-in compatibility UUID 8BAA96B4-5225-471B-B124-D32A349B8106 for Kotlin.ideplugin (org.kotlinlang.xcode.kotlin) not present
unable to restore state from /Users/alessio.borraccino/Documents/workspace/d4l-crypto-ios/.build/workspace-state.json; missingKey("path")
7f2b7dcb6397ec26748115f8ea6cfda7d2c6a1a2c986eac230cbd8f63a9fe14b"
        ),
        .testTarget(name: "Data4LifeCryptoTests",
                    dependencies: ["Data4LifeCrypto"],
                    path: "Crypto/Tests",
                    exclude: ["Info.plist", "Data4LifeCryptoHostApp.xctestplan"],
                    resources: [.process("Resources")]),
    ]
)
