import Foundation
import Command

public func println(message: String) async throws {
    let arguments = ["fastlane", "run", "println", "message:\(message)"]
    
    let commandRunner = CommandRunner()
    for try await event in commandRunner.run(arguments: arguments) {
        print(event.string() ?? "")
    }
}
