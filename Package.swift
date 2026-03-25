// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "FocusFlow",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "FocusFlow",
            targets: ["FocusFlow"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FocusFlow",
            dependencies: [],
            path: "FocusFlow",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "FocusFlowTests",
            dependencies: ["FocusFlow"],
            path: "FocusFlowTests"
        ),
    ]
)
