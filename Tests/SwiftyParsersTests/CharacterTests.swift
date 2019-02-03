import XCTest
@testable import SwiftyParsers

final class CharacterTests: XCTestCase {
    func testSeparete1() {
        let result = separate("")

        XCTAssertNil(result)
    }

    func testSeparete2() {
        let result = separate("abc")

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0, "a")
        XCTAssertEqual(result?.1, "bc")
    }

// TODO: For linux
//    static var allTests = [
//        ("testSeparete1", testSeparete1),
//        ("testSeparete2", testSeparete2),
//        ]
}
