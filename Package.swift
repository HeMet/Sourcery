// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Sourcery",
    platforms: [
       .macOS(.v10_12),
    ],
    products: [
        .executable(name: "sourcery", targets: ["Sourcery"]),
        .library(name: "SourceryRuntime", targets: ["SourceryRuntime"]),
        .library(name: "SourceryStencil", targets: ["SourceryStencil"]),
        .library(name: "SourceryJS", targets: ["SourceryJS"]),
        .library(name: "SourcerySwift", targets: ["SourcerySwift"]),
        .library(name: "SourceryFramework", targets: ["SourceryFramework"]),
    ],
    dependencies: [
        .package(name: "Yams", url: "https://github.com/HeMet/Yams.git", .branch("win-support")),
        .package(name: "Commander", url: "https://github.com/HeMet/Commander.git", .branch("win-support")),
        // PathKit needs to be exact to avoid a SwiftPM bug where dependency resolution takes a very long time.
        .package(name: "PathKit", url: "https://github.com/HeMet/PathKit.git", .branch("win-support")),
        .package(name: "StencilSwiftKit", url: "https://github.com/HeMet/StencilSwiftKit.git", .branch("win-support")),
        .package(name: "XcodeProj", url: "https://github.com/HeMet/xcodeproj", .branch("win-support")),
        .package(name: "SwiftSyntax",
                 url: "https://github.com/HeMet/swift-syntax.git",
                 .branch("win-support"))
    ],
    targets: [
        .target(name: "Sourcery", dependencies: [
            "SourceryFramework",
            "SourceryRuntime",
            "SourceryStencil",
            "SourceryJS",
            "SourcerySwift",
            "Commander",
            "PathKit",
            "Yams",
            "StencilSwiftKit",
            "SwiftSyntax",
            "XcodeProj",
            "TryCatch",
        ]),
        .target(name: "SourceryRuntime"),
        .target(name: "SourceryUtils", dependencies: [
          "PathKit"
        ]),
        .target(name: "SourceryFramework", dependencies: [
          "PathKit",
          "SwiftSyntax",
          "SourceryUtils",
          "SourceryRuntime"
        ]),
        .target(name: "SourceryStencil", dependencies: [
          "PathKit",
          "SourceryRuntime",
          "StencilSwiftKit",
        ]),
        .target(name: "SourceryJS", dependencies: [
          "PathKit"
        ]),
        .target(name: "SourcerySwift", dependencies: [
          "PathKit",
          "SourceryRuntime",
          "SourceryUtils"
        ]),
        .target(name: "TryCatch", path: "TryCatch"),
    ]
)

#if os(Windows)
for target in package.targets {
  // no unix-like symlinks on Windows
  target.path = target.name 
}
#endif