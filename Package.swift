// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pulse",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "Pulse", targets: ["Pulse"]),
    ],
    targets: [
        .target(name: "Pulse"),
        .testTarget(name: "PulseTests", dependencies: ["Pulse"]),
    ]
)
