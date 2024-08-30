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
  name: "fastlane",
  platforms: [.macOS(.v13)],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
    .package(url: "https://github.com/fastlane/swift-fastlane", branch: "main"),
  ],
  targets: [
    .executableTarget(
      name: "fastlane",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "FastlaneKit", package: "swift-fastlane"),
      ]
    )
  ]
)
EOF

# Sources directory
mkdir -p $FASTLANE_SWIFT_DIR/Sources

touch $FASTLANE_SWIFT_DIR/Sources/main.swift
cat <<EOF > $FASTLANE_SWIFT_DIR/Sources/main.swift
import FastlaneKit

try await FastlaneCommand.run()
EOF

touch $FASTLANE_SWIFT_DIR/Sources/Lanes.swift
cat <<EOF > $FASTLANE_SWIFT_DIR/Sources/Lanes.swift
import ArgumentParser
import FastlaneKit

@Lane
struct HelloWorld: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "hello-world"
    )
    
    func run() async throws {
        try await println(message: "Hello, World!")
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