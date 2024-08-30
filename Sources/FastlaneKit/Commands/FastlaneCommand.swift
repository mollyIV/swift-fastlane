import ArgumentParser
import Foundation

@attached(member)
public macro Lane() = #externalMacro(module: "FastlaneMacros", type: "LaneDeclarationMacro")

public struct FastlaneCommand: AsyncParsableCommand, Sendable {
    private static var _subcommands: [any ParsableCommand.Type] = []
    
    public static let configuration = CommandConfiguration(
        commandName: "fastlane",
        abstract: "Perform fastlane operations.",
        subcommands: _subcommands
    )
    
    public init() {}
    
    public static func run() async throws {
        let processedArguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
        
        // Detect lane commands defined marked by the `@Lane` macro.
        let detectedCommands = await withTaskGroup(of: [Self].self) { taskGroup in
            var commands: [any ParsableCommand.Type] = []
            enumerateTypes(withNamesContaining: "__🟠$lane_container__") { type, _ in
                if let type = type as? any __LaneContainer.Type {
                    commands.append(type.__command)
                }
            }
            return commands
        }
        Self._subcommands = detectedCommands
        
        // Run a command.
        do {
            var command = try Self.parseAsRoot(processedArguments)
            if var asyncCommand = command as? (any AsyncParsableCommand) {
                try await asyncCommand.run()
            } else {
                try command.run()
            }
        } catch {
            exit(withError: error)
        }
    }
}
