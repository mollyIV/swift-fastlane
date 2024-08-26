import ArgumentParser
import Foundation

public struct FastlaneCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "fastlane",
        abstract: "Perform fastlane operations.",
        subcommands: [LaneCommand.self]
    )
    
    public init() {}
    
    public static func run(
        _ fastfile: Lanefile
    ) async throws {
        let processedArguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
        
        do {
            var command = try Self.parseAsRoot(processedArguments)
            if var asyncCommand = command as? AsyncParsableCommand {
                try await asyncCommand.run()
            } else {
                try command.run()
            }
        } catch {
            exit(withError: error)
        }
    }
}

private extension FastlaneCommand {
    struct LaneCommand: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "lane",
            abstract: "Run the lane."
        )
        
        @Argument(help: "The name of a lane to execute.")
        var name: String
        
        @Argument(help: "The parameters.")
        var params: [String] = []
        
        public func run() async throws {
            print("Executing lane '\(name)'")
        }
    }
}
