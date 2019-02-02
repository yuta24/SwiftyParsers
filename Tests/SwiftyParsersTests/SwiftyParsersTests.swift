import XCTest
@testable import SwiftyParsers

final class SwiftyParsersTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftyParsers().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
