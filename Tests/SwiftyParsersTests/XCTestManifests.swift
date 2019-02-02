import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ParsersTests.allTests),
        testCase(CharacterTests.allTests),
    ]
}
#endif
