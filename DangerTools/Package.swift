// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "DangerTools",
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.58.2"),
    ],
    targets: [.target(name: "DangerTools", path: "")]
)
