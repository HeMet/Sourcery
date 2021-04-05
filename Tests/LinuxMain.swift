import XCTest
import Quick

@testable import SourceryLibTests

QCKMain([
//    SourcerySpecTests.self,
    AnnotationsParserSpec.self,
    TemplateAnnotationsParserSpec.self,
    VerifierSpec.self,
    FileParserAssociatedTypeSpec.self,
    FileParserAttributesSpec.self,
    FileParserMethodsSpec.self,
    FileParserSubscriptsSpec.self,
    FileParserVariableSpec.self,
//    FileParserSpec.self,
    AnnotationsParserSpec.self,
    TemplateAnnotationsParserSpec.self,
    VerifierSpec.self,
    TypeNameSpec.self,
    ParserComposerSpec.self,
])