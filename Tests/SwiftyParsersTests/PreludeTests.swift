import XCTest
@testable import SwiftyParsers

final class PreludeTests: XCTestCase {
    func testId() {
        XCTAssertEqual(id(123), 123)
    }
}
