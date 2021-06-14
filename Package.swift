// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VDRegex",
    platforms: [
        .iOS(.v11)
    ],
    products: [
			.library(name: "VDRegex", targets: ["VDRegex"]),
    ],
    dependencies: [],
    targets: [
			.target(name: "VDRegex", dependencies: []),
			.testTarget(name: "VDRegexTests", dependencies: ["VDRegex"]),
    ]
)
