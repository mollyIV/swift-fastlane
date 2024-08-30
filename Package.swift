// swift-tools-version: 5.10
import PackageDescription
import CompilerPluginSupport

let argumentParserDependency: Target.Dependency = .product(name: "ArgumentParser", package: "swift-argument-parser")
let commandDependency: Target.Dependency = .product(name: "Command", package: "Command")

let package = Package(
    name: "swift-fastlane",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(name: "FastlaneKit", targets: ["FastlaneKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/tuist/Command", from: "0.8.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "510.0.3"),
    ],
    targets: [
        .target(
            name: "FastlaneKit",
            dependencies: [
                argumentParserDependency,
                commandDependency,
                "_TestingInternals",
                "FastlaneMacros",
            ],
            cxxSettings: .packageSettings,
            swiftSettings: .packageSettings
        ),
        .target(
          name: "_TestingInternals",
          exclude: ["CMakeLists.txt"],
          cxxSettings: .packageSettings
        ),
        .macro(
            name: "FastlaneMacros",
            dependencies: [
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            swiftSettings: .packageSettings
        )
    ],
    cxxLanguageStandard: .cxx20
)

extension Array where Element == PackageDescription.CXXSetting {
  /// Settings intended to be applied to every C++ target in this package.
  /// Analogous to project-level build settings in an Xcode project.
  static var packageSettings: Self {
    [
      .define("_SWT_TESTING_LIBRARY_VERSION", to: #""unknown (Swift 5.10 toolchain)""#),
    ]
  }
}

extension Array where Element == PackageDescription.SwiftSetting {
    /// Settings intended to be applied to every Swift target in this package.
    /// Analogous to project-level build settings in an Xcode project.
    static var packageSettings: Self {
        [
            .unsafeFlags(["-require-explicit-sendable"]),
            .enableUpcomingFeature("ExistentialAny"),
            .enableExperimentalFeature("AccessLevelOnImport"),
            .enableUpcomingFeature("InternalImportsByDefault"),
        ]
    }
}
