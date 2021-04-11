//
// Created by Krzysztof Zablocki on 16/01/2017.
// Copyright (c) 2017 Pixle. All rights reserved.
//

import Quick
import Nimble
import PathKit
#if SWIFT_PACKAGE
import Foundation
@testable import SourceryLib
#else
@testable import Sourcery
#endif
@testable import SourceryFramework
@testable import SourceryRuntime

class TemplateAnnotationsParserSpec: QuickSpec {
    override func spec() {
        describe("InlineParser") {
            context("without indentation") {
                let source =
                        ("// sourcery:inline:Type.AutoCoding\n" +
                        "var something: Int\n" +
                        "// sourcery:end\n").withPlatformLineTerminator

                let result = TemplateAnnotationsParser.parseAnnotations("inline", contents: source)

                it("tracks it") {
                    let annotatedRanges = result.annotatedRanges["Type.AutoCoding"]
                    #if os(Windows)
                    expect(annotatedRanges?.map { $0.range }).to(equal([NSRange(location: 36, length: 20)]))
                    #else
                    expect(annotatedRanges?.map { $0.range }).to(equal([NSRange(location: 35, length: 19)]))
                    #endif
                    expect(annotatedRanges?.map { $0.indentation }).to(equal([""]))
                }

                it("removes content between the markup") {
                    expect(result.contents).to(equal(
                        ("// sourcery:inline:Type.AutoCoding\n" +
                        "// sourcery:end\n").withPlatformLineTerminator
                    ))
                }
            }

            context("with indentation") {
                let source =
                        ("    // sourcery:inline:Type.AutoCoding\n" +
                        "    var something: Int\n" +
                        "    // sourcery:end\n").withPlatformLineTerminator

                let result = TemplateAnnotationsParser.parseAnnotations("inline", contents: source)

                it("tracks it") {
                    let annotatedRanges = result.annotatedRanges["Type.AutoCoding"]
                    #if os(Windows)
                    expect(annotatedRanges?.map { $0.range }).to(equal([NSRange(location: 40, length: 24)]))
                    #else
                    expect(annotatedRanges?.map { $0.range }).to(equal([NSRange(location: 39, length: 23)]))
                    #endif
                    expect(annotatedRanges?.map { $0.indentation }).to(equal(["    "]))
                }

                it("removes content between the markup") {
                    expect(result.contents).to(equal(
                        ("    // sourcery:inline:Type.AutoCoding\n" +
                        "    // sourcery:end\n").withPlatformLineTerminator
                    ))
                }
            }
        }
    }
}
