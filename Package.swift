// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftlyForms",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftlyForms",
            targets: ["SwiftlyForms"]),
        .library(
          name: "SwiftlyFormsField",
          targets: ["SwiftlyFormsField"]
        ),
        .library(
          name: "SwiftlyFormsCore",
          targets: ["SwiftlyFormsCore"]
        )
    ],
    dependencies: [
      .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
      
      .macro(
        name: "SwiftlyFormsMacros",
        dependencies: [
          .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
          .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
        ]
      ),
      .target(
          name: "SwiftlyFormsCore",
          dependencies: ["SwiftlyFormsMacros"]),
      .testTarget(
          name: "SwiftlyFormsCoreTests",
          dependencies: ["SwiftlyFormsCore"]),
      
        .target(
            name: "SwiftlyForms"),
        .testTarget(
            name: "SwiftlyFormsTests",
            dependencies: ["SwiftlyForms", "SwiftlyFormsCore"]),
        
          .target(
              name: "SwiftlyFormsField"),
          .testTarget(
              name: "SwiftlyFormsFieldTests",
              dependencies: ["SwiftlyFormsField", "SwiftlyForms"]),
    ]
)
