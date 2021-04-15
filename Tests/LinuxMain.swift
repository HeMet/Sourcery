import XCTest
import Quick

@testable import SourceryLibTests
import SourceryUtils

SourceryUtils.inUnitTests = true

var allTests: [QuickSpec.Type] = []

//allTests += [
//    ConfigurationSpec.self,
//    GeneratorSpec.self,
//    SourcerySpecTests.self,
//]

allTests += [
//    StencilTemplateSpec.self,
    SwiftTemplateTests.self, //(need to update runtime)
]

//allTests += [
//    ClassSpec.self,
//    DiffableSpec.self,
//    EnumSpec.self,
//    MethodSpec.self,
//    ProtocolSpec.self,
//    StructSpec.self,
//    TypealiasSpec.self,
//    TypeSpec.self,
//    VariableSpec.self,
//]

#if os(Darwin)
allTests += [
    JavaScriptTemplateTests.self,
    TypedSpec.self,
]
#endif

//allTests += [
//    AnnotationsParserSpec.self,
//    TemplateAnnotationsParserSpec.self,
//    VerifierSpec.self,
//    FileParserAssociatedTypeSpec.self,
//    FileParserAttributesSpec.self,
//    FileParserMethodsSpec.self,
//    FileParserSubscriptsSpec.self,
//    FileParserVariableSpec.self,
//    FileParserSpec.self,
//    AnnotationsParserSpec.self,
//    TemplateAnnotationsParserSpec.self,
//    VerifierSpec.self,
//    TypeNameSpec.self,
//    ParserComposerSpec.self,
//]

QCKMain(allTests)