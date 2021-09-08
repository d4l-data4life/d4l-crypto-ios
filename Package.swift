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
            url: "https://d4l-ios-artifact-repository.s3.eu-central-1.amazonaws.com/d4l-data4life/d4l-crypto-ios/Data4LifeCrypto-xcframework-v1.7.0.zip",
            checksum: "f0b8ac45ac6294bd706ce9872738c7e3a23dd00cd3358e280f7cf322558ba3e8"
        ),
        .testTarget(name: "Data4LifeCryptoTests",
                    dependencies: ["Data4LifeCrypto"],
                    path: "Crypto/Tests",
                    exclude: ["Info.plist", "Data4LifeCryptoHostApp.xctestplan"],
                    resources: [.process("Resources")]),
    ]
)
