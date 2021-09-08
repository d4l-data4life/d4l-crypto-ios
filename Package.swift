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
            url: "https://d4l-ios-artifact-repository.s3.eu-central-1.amazonaws.com/d4l-data4life/d4l-crypto-ios/Data4LifeCrypto-xcframework-add-sign-algorithm-unsalted.zip",
            checksum: "0757b891c37c96caececa334660655c907b7e7d7361d5296cfd20a195afefeb3"
        ),
        .testTarget(name: "Data4LifeCryptoTests",
                    dependencies: ["Data4LifeCrypto"],
                    path: "Crypto/Tests",
                    exclude: ["Info.plist", "Data4LifeCryptoHostApp.xctestplan"],
                    resources: [.process("Resources")]),
    ]
)
