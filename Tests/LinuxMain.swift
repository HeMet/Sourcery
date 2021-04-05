import XCTest
import Quick

@testable import SourceryLibTests

QCKMain([
//    SourcerySpecTests.self,
    AnnotationsParserSpec.self,
    TemplateAnnotationsParserSpec.self,
    VerifierSpec.self,
    FileParserAssociatedTypeSpec.self,
    ParserComposerSpec.self,
])