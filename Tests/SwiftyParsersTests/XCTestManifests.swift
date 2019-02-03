import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return []
// TODO: For linux
//    return [
//        testCase(ParsersTests.allTests),
//        testCase(CharacterTests.allTests),
//    ]
}
#endif
