// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ATCommonTools",
    platforms: [
        .iOS(.v14),
        .macOS(.v12),
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
    dependencies: [
        .package(url: "https://github.com/ATProtoKit/MultiformatsKit.git", .upToNextMajor(from: "0.3.0")),
        .package(url: "https://github.com/nnabeyang/swift-cbor", from: "0.0.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ATCommonTools",
            dependencies: [
                "ATCommonWeb",
                .product(name: "MultiformatsKit", package: "multiformatskit"),
                .product(name: "SwiftCbor", package: "swift-cbor")
            ]
        ),
        .target(
            name: "ATCommonWeb",
            dependencies: [
                .product(name: "MultiformatsKit", package: "multiformatskit")
            ]
        ),
        .testTarget(
            name: "ATCommonToolsTests",
            dependencies: ["ATCommonTools", "ATCommonWeb"]
        ),
    ]
)

let swiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("StrictConcurrency"),
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableUpcomingFeature("GlobalActorIsolatedTypesUsability"),
    .enableUpcomingFeature("InferSendableFromCaptures"),
]

for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(contentsOf: swiftSettings)
    target.swiftSettings = settings
}
