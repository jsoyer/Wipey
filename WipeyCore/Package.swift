// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WipeyCore",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "WipeyCore", targets: ["WipeyCore"])
    ],
    targets: [
        .target(
            name: "WipeyCore",
            path: "Sources/WipeyCore"
        ),
        .testTarget(
            name: "WipeyCoreTests",
            dependencies: ["WipeyCore"],
            path: "Tests/WipeyCoreTests"
        )
    ]
)
