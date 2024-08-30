## 🚀 What's Fastlane Swift 

Fastlane Swift is a Swift library that provides a simple and easy way to interact with the Fastlane API.

## ⬇️ Install

Go to your project root directory and run the following command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mollyIV/swift-fastlane/main/lane.sh)"
```

The script will generate new Swift package in `./fastlane/swift` directory.

## 📝 Usage

**Prerequisites:**
- Fastlane Ruby installed; it is required to run the Fastlane Swift commands.

To add a new lane, you need to create a new [Swift command](https://github.com/apple/swift-argument-parser?tab=readme-ov-file#usage) and mark it with `@Lane` attribute. For example:

```swift
@Lane
struct MyCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "my-command"
    )
    
    func run() async throws {
        try await println(message: "Hello, World!")
    }
}
```

To run the lane, you need to call the `fastlane` command with the lane type as a parameter. For example:

```bash
$ swift run fastlane my-command
```