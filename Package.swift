// swift-tools-version: 6.0
import PackageDescription

let package = Package(
   name: "IntelligenceKit",
   platforms: [.iOS(.v18), .macOS(.v15), .tvOS(.v18), .visionOS(.v2), .watchOS(.v11)],
   products: [.library(name: "IntelligenceKit", targets: ["IntelligenceKit"])],
   dependencies: [
      .package(url: "https://github.com/FlineDev/HandySwift.git", branch: "main"),
      .package(url: "https://github.com/FlineDev/ErrorKit.git", branch: "main"),
   ],
   targets: [
      .target(
         name: "IntelligenceKit",
         dependencies: [
            .product(name: "HandySwift", package: "HandySwift"),
            .product(name: "ErrorKit", package: "ErrorKit"),
         ]
      ),
      .testTarget(
         name: "IntelligenceKitTests",
         dependencies: ["IntelligenceKit"]
      )
   ]
)
