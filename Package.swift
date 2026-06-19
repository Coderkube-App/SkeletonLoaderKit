// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SkeletonLoaderKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "SkeletonLoaderKit",
            targets: ["SkeletonLoaderKit"]
        )
    ],
    targets: [
        .target(
            name: "SkeletonLoaderKit",
            path: "Sources/SkeletonLoaderKit"
        ),
        .testTarget(
            name: "SkeletonLoaderKitTests",
            dependencies: ["SkeletonLoaderKit"],
            path: "Tests/SkeletonLoaderKitTests"
        )
    ]
)
