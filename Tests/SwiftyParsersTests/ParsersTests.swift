import XCTest
@testable import SwiftyParsers

final class ParsersTests: XCTestCase {
    func testChar1() {
        let result = char("a").parse("abc")

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0, "a")
        XCTAssertEqual(result?.1, "bc")
    }

    func testChar2() {
        let result = char("a").parse("bc")

        XCTAssertNil(result)
    }

    func testNotChar1() {
        let result = notChar("a").parse("bc")

        XCTAssertNotNil(result)
    }

    func testNotChar2() {
        let result = notChar("b").parse("abc")

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0, "a")
        XCTAssertEqual(result?.1, "bc")
    }

    func testAny1() {
        let result = any().parse("abc")

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0, "a")
        XCTAssertEqual(result?.1, "bc")
    }

    func testAny2() {
        let result = any().parse("")

        XCTAssertNil(result)
    }

    func testString1() {
        let result = string("ab").parse("abc")

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0, "ab")
        XCTAssertEqual(result?.1, "c")
    }

    func testString2() {
        let result = string("b").parse("abc")

        XCTAssertNil(result)
    }

    func testOctDigit1() {
        let result = octDigit().parse("012")

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0, "0")
        XCTAssertEqual(result?.1, "12")
    }

    func testOctDigit2() {
        let result = octDigit().parse("a")

        XCTAssertNil(result)
    }

    
    static var allTests = [
        ("testChar1", testChar1),
        ("testChar2", testChar2),
        ("testNotChar1", testNotChar1),
        ("testNotChar2", testNotChar2),
        ("testAny1", testAny1),
        ("testAny2", testAny2),
        ("testString1", testString1),
        ("testString2", testString2),
        ("testOctDigit1", testOctDigit1),
        ("testOctDigit2", testOctDigit2),
        ]
}
