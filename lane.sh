#!/bin/bash

set -e

FASTLANE_SWIFT_DIR="fastlane/swift"

if [ -d $FASTLANE_SWIFT_DIR ]; then
  echo "The fastlane/swift directory already exists."
  exit 1
fi

mkdir -p $FASTLANE_SWIFT_DIR

# Package.swift file
touch $FASTLANE_SWIFT_DIR/Package.swift
cat <<EOF > $FASTLANE_SWIFT_DIR/Package.swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "fastlane-swift",
  platforms: [.macOS(.v10_15)],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
    .package(url: "https://github.com/fastlane/fastlane", from: "2.223.0"),
  ],
  targets: [
    .executableTarget(
      name: "fastlane-swift",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "Fastlane", package: "fastlane"),
      ]
    )
  ]
)
EOF

# Sources directory
mkdir -p $FASTLANE_SWIFT_DIR/Sources

touch $FASTLANE_SWIFT_DIR/Sources/Runner.swift
cat <<EOF > $FASTLANE_SWIFT_DIR/Sources/Runner.swift
import ArgumentParser
import Fastlane

@main
struct Fastlane: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "Peforming fastlane operations.",
    subcommands: [Lane.self]
  )
}

extension Fastlane {
    struct Lane: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Runs the given lane.")

        @Argument(help: "The name of a lane to execute.")
        var name: String

        @Argument(help: "The parameters.")
        var params: [String] = []

        mutating func run() throws {
            Main().run(with: FastFile())
        }
    }
}
EOF

touch $FASTLANE_SWIFT_DIR/Sources/Fastfile.swift
cat <<EOF > $FASTLANE_SWIFT_DIR/Sources/Fastfile.swift
import Fastlane

class FastFile: LaneFile {
    func foobarLane() {
        println(message: "Hello, World!")
    }
}
EOF

# .gitignore file
touch $FASTLANE_SWIFT_DIR/.gitignore
cat <<EOF > $FASTLANE_SWIFT_DIR/.gitignore
.build
.DS_Store
.swiftpm
.vscode
EOF

echo "The fastlane-swift package has been created."

# Open the fastlane/swift directory Package.swift file in Xcode
open $FASTLANE_SWIFT_DIR/Package.swift