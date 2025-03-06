// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LogoREGICore",
    platforms: [.iOS(.v17), .macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LogoREGICore",
            targets: ["LogoREGICore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.0.0"),
        .package(url: "https://github.com/yaslab/ULID.swift.git", from: "1.3.0"),
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.52.0"),
        .package(url: "https://github.com/KaguraGateway/cafelogos-grpc.git", .upToNextMajor(from: "0.1.0")),
        .package(url: "https://github.com/connectrpc/connect-swift", from: "0.8.0"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.24.0"),
        .package(url: "https://github.com/star-micronics/StarXpand-SDK-iOS", from: "2.6.0"),
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LogoREGICore", dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "StarIO10", package: "StarXpand-SDK-iOS"),
                .product(name: "ULID", package: "ULID.swift"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "Connect", package: "connect-swift"),
                .product(name: "cafelogos-grpc", package: "cafelogos-grpc")
            ]),
        .testTarget(
            name: "LogoREGICoreTests",
            dependencies: ["LogoREGICore"]
        ),
    ]
)
