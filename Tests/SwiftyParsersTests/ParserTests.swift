import XCTest
@testable import SwiftyParsers

final class ParserTests: XCTestCase {
    let cp = Parser<Character> {
        return separate($0)
    }
    let ip = Parser<Int> {
        if let (x, xs) = separate($0), let i = Int(String(x)) {
            return (i, xs)
        } else {
            return nil
        }
    }

    func testId() {
        XCTAssertEqual(id(123), 123)
    }

    func testFunctor1() {
        let p1 = cp
        let p2 = p1.fmap({ (c) -> Int? in
            return Int(String(c))
        })

        let r1 = p2.parse("123")
        XCTAssertNotNil(r1)
        XCTAssertEqual(r1?.0, 1)
        XCTAssertEqual(r1?.1, "23")

        let r2 = p2.parse("abc")
        XCTAssertNotNil(r2)
        XCTAssertEqual(r2?.0, nil)
        XCTAssertEqual(r2?.1, "bc")
    }

    func testApplicative1() {
        let p1 = Parser<Character>.pure("a")

        let r = p1.parse("123")
        XCTAssertNotNil(r)
        XCTAssertEqual(r?.0, "a")
        XCTAssertEqual(r?.1, "123")
    }

    func testApplicative2() {
        let p1 = cp
        let p2 = Parser<(Character) -> Int?>.pure({ Int(String($0)) })
        let p3 = p1.seq(p2)

        let r1 = p3.parse("123")
        XCTAssertNotNil(r1)
        XCTAssertEqual(r1?.0, 1)
        XCTAssertEqual(r1?.1, "23")

        let r2 = p3.parse("abc")
        XCTAssertNotNil(r2)
        XCTAssertNil(r2?.0)
        XCTAssertEqual(r2?.1, "bc")

        let r3 = p3.parse("")
        XCTAssertNil(r3)
    }

    func testApplicative3() {
        let p1 = cp
        let p2 = ip
        let p3 = p1.seqDiscardRight(p2)

        let r1 = p3.parse("a1c")
        XCTAssertNotNil(r1)
        XCTAssertEqual(r1?.0, "a")
        XCTAssertEqual(r1?.1, "c")

        let r2 = p3.parse("abc")
        XCTAssertNil(r2)
    }

    func testApplicative4() {
        let p1 = cp
        let p2 = ip
        let p3 = p1.seqDiscardLeft(p2)

        let r1 = p3.parse("a1c")
        XCTAssertNotNil(r1)
        XCTAssertEqual(r1?.0, 1)
        XCTAssertEqual(r1?.1, "c")

        let r2 = p3.parse("abc")
        XCTAssertNil(r2)
    }

    func testMonad1() {
        let p1 = cp
        let p2 = { (c: Character) -> Parser<Int?> in
            return .pure(Int(String(c)))
        }
        let p3 = p1.flatMap(p2)

        let r1 = p3.parse("123")
        XCTAssertNotNil(r1)
        XCTAssertEqual(r1?.0, 1)
        XCTAssertEqual(r1?.1, "23")

        let r2 = p3.parse("abc")
        XCTAssertNotNil(r2)
        XCTAssertNil(r2?.0)
        XCTAssertEqual(r2?.1, "bc")
    }

    func testAlternative1() {
        enum Tuple {
            case left
            case right
        }
        let p1 = ip.fmap({ _ in Tuple.left })
        let p2 = cp.fmap({ _ in Tuple.right })
        let p3 = Parser<Tuple>.choice(p1, p2)

        let r1 = p3.parse("123")
        XCTAssertNotNil(r1)
        XCTAssertEqual(r1?.0, .left)
        XCTAssertEqual(r1?.1, "23")

        let r2 = p3.parse("abc")
        XCTAssertNotNil(r2)
        XCTAssertEqual(r2?.0, .right)
        XCTAssertEqual(r2?.1, "bc")
    }

// TODO: For linux
//    static var allTests = [
//        ("testFunctor1", testFunctor1),
//        ("testApplicative1", testApplicative1),
//        ("testApplicative2", testApplicative2),
//        ("testMonad1", testMonad1),
//    ]
}
