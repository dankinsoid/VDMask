# VDRegex
 syntaxis for regex
 ## Example
```swift
//email regex "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.]+\\.[A-Za-z]{2,64}"

let emailRegex1 = Regex {
  ["A"-"Z", 0-9, "a"-"z", "._%+-"]+
  "@"
  ["A"-"Z", 0-9, "a"-"z", "."]+
  "."
  Regex["A"-"Z", "a"-"z"].count(2...64)
}
 
let emailRegex2 = Regex[.alphanumeric, "._%+-"]("@")[.alphanumeric, "."](".")[.alphabetic].count(2...64)
 
//phone regex "+[0-9]-\\([0-9]{3}\\)-[0-9]{3}(-[0-9]{2}){2}"
 
let phoneRegexShort = Regex("+")[0-9]("-(")[0-9]({3})(")-")[0-9]({3})(Regex("-")[0-9]({2}))({2})
 
let phoneRegexReadable = Regex {
  "+"
  Regex[0-9]
  "-("
  Regex[0-9].count(3)
  ")-"
  Regex[0-9].count(3)
  Regex.group {
    "-"
    Regex[0-9].count(2)
  }.count(2)
}
```
 ## Installation
 1. [Swift Package Manager](https://github.com/apple/swift-package-manager)
 
 Create a `Package.swift` file.
 ```swift
 // swift-tools-version:5.0
 import PackageDescription
 
 let package = Package(
 name: "SomeProject",
 dependencies: [
 .package(url: "https://github.com/dankinsoid/VDRegex.git", from: "1.2.0")
 ],
 targets: [
 .target(name: "SomeProject", dependencies: ["VDRegex"])
 ]
 )
 ```
 ```ruby
 $ swift build
 ```
