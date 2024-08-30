import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct LaneMacrosMain: CompilerPlugin {
  var providingMacros: [any Macro.Type] {
    [
        LaneDeclarationMacro.self,
    ]
  }
}
