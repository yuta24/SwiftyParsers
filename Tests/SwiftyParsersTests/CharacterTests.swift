import XCTest
@testable import SwiftyParsers

final class CharacterTests: XCTestCase {
    func testSeparete1() {
        let result = separete("")

        XCTAssertNil(result)
    }

    func testSeparete2() {
        let result = separete("abc")

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0, "a")
        XCTAssertEqual(result?.1, "bc")
    }

    func testIsDigit1() {
        XCTAssertTrue(isDigit("0"))
        XCTAssertTrue(isDigit("1"))
        XCTAssertTrue(isDigit("2"))
        XCTAssertTrue(isDigit("3"))
        XCTAssertTrue(isDigit("4"))
        XCTAssertTrue(isDigit("5"))
        XCTAssertTrue(isDigit("6"))
        XCTAssertTrue(isDigit("7"))
        XCTAssertTrue(isDigit("8"))
        XCTAssertTrue(isDigit("9"))
    }

    func testIsDigit2() {
        XCTAssertFalse(isDigit("a"))
    }

    func testIsLower1() {
        XCTAssertTrue(isLower("a"))
        XCTAssertTrue(isLower("b"))
        XCTAssertTrue(isLower("c"))
        XCTAssertTrue(isLower("d"))
        XCTAssertTrue(isLower("e"))
        XCTAssertTrue(isLower("f"))
        XCTAssertTrue(isLower("g"))
        XCTAssertTrue(isLower("h"))
        XCTAssertTrue(isLower("i"))
        XCTAssertTrue(isLower("j"))
        XCTAssertTrue(isLower("k"))
        XCTAssertTrue(isLower("l"))
        XCTAssertTrue(isLower("m"))
        XCTAssertTrue(isLower("n"))
        XCTAssertTrue(isLower("o"))
        XCTAssertTrue(isLower("p"))
        XCTAssertTrue(isLower("q"))
        XCTAssertTrue(isLower("r"))
        XCTAssertTrue(isLower("s"))
        XCTAssertTrue(isLower("t"))
        XCTAssertTrue(isLower("u"))
        XCTAssertTrue(isLower("v"))
        XCTAssertTrue(isLower("w"))
        XCTAssertTrue(isLower("x"))
        XCTAssertTrue(isLower("y"))
        XCTAssertTrue(isLower("z"))
    }

    func testIsLower2() {
        XCTAssertFalse(isLower("A"))
        XCTAssertFalse(isLower("1"))
    }

    func testIsUpper1() {
        XCTAssertTrue(isUpper("A"))
        XCTAssertTrue(isUpper("B"))
        XCTAssertTrue(isUpper("C"))
        XCTAssertTrue(isUpper("D"))
        XCTAssertTrue(isUpper("E"))
        XCTAssertTrue(isUpper("F"))
        XCTAssertTrue(isUpper("G"))
        XCTAssertTrue(isUpper("H"))
        XCTAssertTrue(isUpper("I"))
        XCTAssertTrue(isUpper("J"))
        XCTAssertTrue(isUpper("K"))
        XCTAssertTrue(isUpper("L"))
        XCTAssertTrue(isUpper("M"))
        XCTAssertTrue(isUpper("N"))
        XCTAssertTrue(isUpper("O"))
        XCTAssertTrue(isUpper("P"))
        XCTAssertTrue(isUpper("Q"))
        XCTAssertTrue(isUpper("R"))
        XCTAssertTrue(isUpper("S"))
        XCTAssertTrue(isUpper("T"))
        XCTAssertTrue(isUpper("U"))
        XCTAssertTrue(isUpper("V"))
        XCTAssertTrue(isUpper("W"))
        XCTAssertTrue(isUpper("X"))
        XCTAssertTrue(isUpper("Y"))
        XCTAssertTrue(isUpper("Z"))
    }

    func testIsUpper2() {
        XCTAssertFalse(isUpper("a"))
        XCTAssertFalse(isUpper("1"))
    }

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

    static var allTests = [
        ("testSeparete1", testSeparete1),
        ("testSeparete2", testSeparete2),
        ("testIsDigit1", testIsDigit1),
        ("testIsDigit2", testIsDigit2),
        ("testIsLower1", testIsLower1),
        ("testIsLower2", testIsLower2),
        ("testIsUpper1", testIsUpper1),
        ("testIsUpper2", testIsUpper2),
        ("testChar1", testChar1),
        ("testChar2", testChar2),
        ("testNotChar1", testNotChar1),
        ("testNotChar2", testNotChar2),
        ("testAny1", testAny1),
        ("testAny2", testAny2),
        ("testString1", testString1),
        ("testString2", testString2),
        ]
}
