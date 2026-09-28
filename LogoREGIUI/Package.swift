// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LogoREGIUI",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LogoREGIUI",
            targets: ["LogoREGIUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.18.0"),
        .package(url: "https://github.com/yaslab/ULID.swift.git", from: "1.3.0"),
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.52.0"),
        .package(url: "https://github.com/KaguraGateway/logosone.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.29.0"),
        .package(url: "https://github.com/connectrpc/connect-swift.git", from: "1.0.2"),
        .package(url: "https://github.com/star-micronics/StarXpand-SDK-iOS", from: "2.8.0"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
        .package(url: "https://github.com/cybozu/WebUI.git", from: "3.0.0"),
        .package(path: "./LogoREGICore")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LogoREGIUI", dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "StarIO10", package: "StarXpand-SDK-iOS"),
                .product(name: "ULID", package: "ULID.swift"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "Connect", package: "connect-swift"),
                .product(name: "cafelogos-grpc", package: "logosone"),
                .product(name: "WebUI", package: "WebUI"),
                .product(name: "LogoREGICore", package: "LogoREGICore")
            ]),
        .testTarget(
            name: "LogoREGIUITests",
            dependencies: ["LogoREGIUI"]
        ),
    ]
)
