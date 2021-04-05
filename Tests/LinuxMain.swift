import XCTest
import Quick

@testable import SourceryLibTests

QCKMain([
//    SourcerySpecTests.self,
    // Models
    ClassSpec.self,
    DiffableSpec.self,
    EnumSpec.self,
    MethodSpec.self,
    ProtocolSpec.self,
    StructSpec.self,
    TypealiasSpec.self,
//    TypedSpec.self, (KVC)
    TypeSpec.self,
    VariableSpec.self,
    // Parsing
    AnnotationsParserSpec.self,
    TemplateAnnotationsParserSpec.self,
    VerifierSpec.self,
    FileParserAssociatedTypeSpec.self,
    FileParserAttributesSpec.self,
    FileParserMethodsSpec.self,
    FileParserSubscriptsSpec.self,
    FileParserVariableSpec.self,
    FileParserSpec.self,
    AnnotationsParserSpec.self,
    TemplateAnnotationsParserSpec.self,
    VerifierSpec.self,
    TypeNameSpec.self,
    ParserComposerSpec.self,
])