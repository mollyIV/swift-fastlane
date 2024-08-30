import SwiftSyntax
import SwiftSyntaxMacros

public struct LaneDeclarationMacro: MemberMacro, Sendable {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // TODO: Handle diagnose issues
        
        return _createLaneContainerDecls(
            for: declaration,
            laneAttribute: node,
            in: context
        )
    }
    
    private static func _createLaneContainerDecls(
        for declaration: some DeclGroupSyntax,
        laneAttribute: AttributeSyntax,
        in context: some MacroExpansionContext
    ) -> [DeclSyntax] {
        var result = [DeclSyntax]()
        
        let typeName = declaration.type.tokens(viewMode: .fixedUp)
            .map(\.textWithoutBackticks)
            .joined()
        
        let enumName = context.makeUniqueName("__🟠$lane_container__\(typeName)")
        
        result.append(
          """
          @available(*, deprecated, message: "This type is an implementation detail of the fastlane library. Do not use it directly.")
          @frozen enum \(enumName): FastlaneKit.__LaneContainer {
            static var __command: ParsableCommand.Type {
              get {
                \(raw: typeName).self
              }
            }
          }
          """
        )
        
        return result
    }
}

extension DeclGroupSyntax {
    /// The type declared or extended by this instance.
    var type: TypeSyntax {
        if let namedDecl = asProtocol((any NamedDeclSyntax).self) {
            return TypeSyntax(IdentifierTypeSyntax(name: namedDecl.name))
        } else if let extensionDecl = `as`(ExtensionDeclSyntax.self) {
            return extensionDecl.extendedType
        }
        fatalError("Unexpected DeclGroupSyntax type \(Swift.type(of: self)). Please file a bug report at https://github.com/apple/swift-testing/issues/new")
    }
}

extension TokenSyntax {
    var textWithoutBackticks: String {
        text.filter { $0 != "`" }
    }
}
