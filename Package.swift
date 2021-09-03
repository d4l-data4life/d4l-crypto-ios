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
                 url: "https://d4l-ios-artifact-repository.s3.eu-central-1.amazonaws.com/d4l-data4life/d4l-crypto-ios/Data4LifeCrypto-xcframework-1.7.0.zip",
                 .branch("feature/shrink-to-package-only"))

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
            url: "https://d4l-ios-artifact-repository.s3.eu-central-1.amazonaws.com/d4l-data4life/d4l-crypto-ios/Data4LifeCrypto-xcframework-1.7.0.zip",
            checksum: "998813cdfe12061d42dc909b0510a439aaf14a6de967a858ba253cc2b8e29c57"
        ),
        .testTarget(name: "Data4LifeCryptoTests",
                    dependencies: ["Data4LifeCrypto"],
                    path: "Crypto/Tests",
                    exclude: ["Info.plist", "Data4LifeCryptoHostApp.xctestplan"],
                    resources: [.process("Resources")]),
    ]
)
