// swift-tools-version:5.3

import PackageDescription
import Foundation

let sourceryDependencies: [Target.Dependency] = [
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
    "TryCatch"
]

let package = Package(
    name: "Sourcery",
    platforms: [
       .macOS(.v10_12),
    ],
    products: [
        .executable(name: "sourcery", targets: ["Sourcery"]),
        // For testing purpose. The linker has problems linking against executable.
        .library(name: "SourceryLib", targets: ["SourceryLib"]),
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
                 .branch("win-support")),
        .package(url: "https://github.com/Quick/Quick.git", from: "3.0.0"),
        .package(url: "https://github.com/HeMet/Nimble.git", .branch("win-support"))
    ],
    targets: [
        .target(
            name: "Sourcery",
            dependencies: sourceryDependencies,
            exclude: [
                "Templates",
                "Info.plist"
            ]
        ),
        .target(
            name: "SourceryLib",
            dependencies: sourceryDependencies,
            path: "Sourcery",
            exclude: [
                "main.swift",
                "Templates",
                "Info.plist"
            ]
        ),
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
        .target(
            name: "SourceryJS",
            dependencies: [
                "PathKit"
            ],
            exclude: [
                "Info.plist"
            ],
            resources: [
                .copy("Resources/ejs.js")
            ]
        ),
        .target(name: "SourcerySwift", dependencies: [
          "PathKit",
          "SourceryRuntime",
          "SourceryUtils"
        ]),
        .target(
            name: "CodableContext",
            path: "Templates/Tests",
            exclude: [
                "Context/AutoCases.swift",
                "Context/AutoEquatable.swift",
                "Context/AutoHashable.swift",
                "Context/AutoLenses.swift",
                "Context/AutoMockable.swift",
                "Context/LinuxMain.swift",
                "Generated/AutoCases.generated.swift",
                "Generated/AutoEquatable.generated.swift",
                "Generated/AutoHashable.generated.swift",
                "Generated/AutoLenses.generated.swift",
                "Generated/AutoMockable.generated.swift",
                "Generated/LinuxMain.generated.swift",
                "Expected",
                "Info.plist",
                "TemplatesTests.swift"
            ],
            sources: [
                "Context/AutoCodable.swift",
                "Generated/AutoCodable.generated.swift"
            ]
        ),
        .target(name: "TryCatch", path: "TryCatch", exclude: ["Info.plist"]),
        .testTarget(
            name: "SourceryLibTests",
            dependencies: [
                "SourceryLib",
                "Quick",
                "Nimble"
            ],
            exclude: [
                "Info.plist"
            ],
            resources: [
                .copy("Stub/Configs"),
                .copy("Stub/Errors"),
                .copy("Stub/JavaScriptTemplates"),
                .copy("Stub/SwiftTemplates"),
                .copy("Stub/Performance-Code"),
                .copy("Stub/Result"),
                .copy("Stub/Templates"),
                .copy("Stub/Source")
            ]
        ),
        .testTarget(
            name: "CodableContextTests",
            dependencies: [
                "CodableContext",
                "Quick",
                "Nimble"
            ],
            path: "Templates/CodableContextTests",
            exclude: [
                "Info.plist"
            ]
        ),
        .testTarget(
            name: "TemplatesTests",
            dependencies: [
                "Quick",
                "Nimble",
                "PathKit"
            ],
            path: "Templates",
            exclude: [
                "CodableContext",
                "CodableContextTests",
                "Tests/Generated",
                "Tests/Info.plist",
                "default.profraw"
            ],
            sources: [
                // LinuxMain is not compiled as part of the target
                // since there is no way to run script before compilation begins.
                "Tests/TemplatesTests.swift"
            ],
            resources: [
                .copy("Templates"),
                .copy("Tests/Context"),
                .copy("Tests/Expected")
            ]
        )
    ]
)

#if !os(Windows)
hookInternalSwiftSyntaxParser()

/// We need to manually add an -rpath to the project so the tests can run via Xcode
/// If we are running from console (swift build & friend) we don't need to do it
func hookInternalSwiftSyntaxParser() {
    let isFromTerminal = ProcessInfo.processInfo.environment.values.contains("/usr/bin/swift")
    if !isFromTerminal {
        package
            .targets
            .filter(\.isTest)
            .forEach { $0.installSwiftSyntaxParser() }
    }
}

extension PackageDescription.Target {
    func installSwiftSyntaxParser() {
        linkerSettings = [.unsafeFlags(["-rpath", packageRoot])]
    }

    var packageRoot: String {
        return URL(fileURLWithPath: #file).deletingLastPathComponent().path
    }
}
#endif