// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "AttributedString",
    products: [
        .library(name: "AttributedString", targets: ["AttributedString"]),
    ],
    targets: [
        .target(name: "AttributedString"),
        .testTarget(name: "AttributedStringTests", dependencies: ["AttributedString"]),
    ]
)
