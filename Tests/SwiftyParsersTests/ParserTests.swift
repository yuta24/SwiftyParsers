import XCTest
@testable import SwiftyParsers

final class ParserTests: XCTestCase {
    func testMonadic1() {
        let p1 = Parser<Character> {
            return separate($0)
        }
        let p2 = fmap(p1) { (c) -> Int in
            return Int(String(c)) ?? 0
        }

        let r = p2.parse("123")
        XCTAssertNotNil(r)
        XCTAssertEqual(r?.0, 1)
        XCTAssertEqual(r?.1, "23")
    }

    func testMonadic2() {
        let p1: Parser<Character> = pure("a")

        let r = p1.parse("123")
        XCTAssertNotNil(r)
        XCTAssertEqual(r?.0, "a")
        XCTAssertEqual(r?.1, "123")
    }

    func testMonadic3() {
        let p1 = Parser<Character> {
            return separate($0)
        }
        let p2 = Parser<(Character) -> Int> {
            if let (x, xs) = separate($0), let _ = Int(String(x)) {
                return ({ Int(String($0)) ?? 0  }, xs)
            } else {
                return nil
            }
        }
        let p3 = seq(p2, p1)

        let r = p3.parse("123")
        XCTAssertNotNil(r)
        XCTAssertEqual(r?.0, 2)
        XCTAssertEqual(r?.1, "3")
    }

    func testMonadic4() {
        let p1 = Parser<Character> {
            return separate($0)
        }
        let p2 = { (c: Character) -> Parser<Int> in
            return Parser<Int> {
                if let (x, xs) = separate($0), let i = Int(String(x)) {
                    return (i, xs)
                } else {
                    return nil
                }
            }
        }
        let p3 = flatMap(p1, p2)

        let r = p3.parse("123")
        XCTAssertNotNil(3)
        XCTAssertEqual(r?.0, 2)
        XCTAssertEqual(r?.1, "3")
    }

    static var allTests = [
        ("testMonadic1", testMonadic1),
        ("testMonadic2", testMonadic2),
        ("testMonadic3", testMonadic3),
        ("testMonadic4", testMonadic4),
    ]
}
