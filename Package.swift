// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "BabyAgeTracker",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "BabyAgeTracker",
            targets: ["BabyAgeTracker"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BabyAgeTracker",
            dependencies: []),
        .testTarget(
            name: "BabyAgeTrackerTests",
            dependencies: ["BabyAgeTracker"]),
    ]
)
