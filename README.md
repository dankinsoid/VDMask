# VDRegex
 syntaxis for regex
 ## Installation
 1. [Swift Package Manager](https://github.com/apple/swift-package-manager)
 
 Create a `Package.swift` file.
 ```swift
 // swift-tools-version:5.0
 import PackageDescription
 
 let package = Package(
 name: "SomeProject",
 dependencies: [
 .package(url: "https://github.com/dankinsoid/VDRegex.git", from: "0.2.0")
 ],
 targets: [
 .target(name: "SomeProject", dependencies: ["VDRegex"])
 ]
 )
 ```
 ```ruby
 $ swift build
 ```
