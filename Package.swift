// swift-tools-version: 5.9
import PackageDescription

let argumentParserDependency: Target.Dependency = .product(name: "ArgumentParser", package: "swift-argument-parser")

let package = Package(
    name: "swift-fastlane",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "FastlaneKit", targets: ["FastlaneKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
    ],
    targets: [
        .target(
            name: "FastlaneKit",
            dependencies: [
                argumentParserDependency,
            ]
        )
    ]
)
