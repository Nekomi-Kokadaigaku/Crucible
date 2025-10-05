// swift-tools-version: 5.11
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Crucible",
  platforms: [
    .macOS(.v11),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Crucible",
      targets: ["Crucible"]
    )
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "Crucible"
    ),
    .testTarget(
      name: "CrucibleTests",
      dependencies: ["Crucible"]
    ),
  ]
)
