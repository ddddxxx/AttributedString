// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "AttributedString",
    products: [
        .library(
            name: "AttributedString",
            targets: ["AttributedString"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "AttributedString",
            dependencies: []),
        .testTarget(
            name: "AttributedStringTests",
            dependencies: ["AttributedString"]),
    ]
)
