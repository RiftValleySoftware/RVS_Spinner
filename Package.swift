// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "RVS_Spinner",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "RVS-Spinner",
            type: .dynamic,
            targets: ["RVS_Spinner"])
    ],
    targets: [
        .target(
            name: "RVS_Spinner",
            path: "./src")
    ]
)
