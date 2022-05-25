// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Dependency",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(name: "Dependency", targets: ["Dependency"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Dependency", dependencies: []),
        .testTarget(name: "DependencyTests", dependencies: ["Dependency"]),
    ]
)
