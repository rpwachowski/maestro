// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Maestro",
    platforms: [.iOS(.v14), .macOS(.v11), .tvOS(.v14), .watchOS(.v7)],
    products: [.library(name: "Maestro", targets: ["Maestro"])],
    dependencies: [],
    targets: [
        .target(name: "Maestro-ObjC", dependencies: []),
        .target(name: "Maestro", dependencies: ["Maestro-ObjC"]),
        .testTarget(name: "MaestroTests", dependencies: ["Maestro"]),
    ]
)
