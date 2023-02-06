# VDMask

 ## Example
```swift
let phoneMaskShort = Mask("+#-(###)-###-##-##", ["#": "0"..."9"])
 
let phoneMask = Mask {
  "+"
  Repeat("0"..."9", 1)
  "-("
  Repeat("0"..."9", 3)
  ")-"
  Repeat("0"..."9", 3)
  Repeat(2) {
		"-"
		Repeat("0"..."9", 2)
	}
}.joined()
```
 ## Installation
 1. [Swift Package Manager](https://github.com/apple/swift-package-manager)
 
 Create a `Package.swift` file.
 ```swift
 // swift-tools-version:5.7
 import PackageDescription
 
 let package = Package(
   name: "SomeProject",
   dependencies: [
     .package(url: "https://github.com/dankinsoid/VDMask.git", from: "2.0.0")
   ],
   targets: [
    .target(name: "SomeProject", dependencies: ["VDMask"])
   ]
  )
```
```ruby
$ swift build
```
