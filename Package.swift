// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ATCommonTools",
    platforms: [
        .iOS(.v14),
        .macOS(.v13),
        .tvOS(.v14),
        .visionOS(.v1),
        .watchOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ATCommonTools",
            targets: ["ATCommonTools"]),
        .library(
            name: "ATCommonWeb",
            targets: ["ATCommonWeb"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ATCommonTools",
            dependencies: [
                "ATCommonWeb"
            ]
        ),
        .target(name: "ATCommonWeb"),
        .testTarget(
            name: "ATCommonToolsTests",
            dependencies: ["ATCommonTools", "ATCommonWeb"]
        ),
    ]
)
