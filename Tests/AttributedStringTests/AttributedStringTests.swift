import XCTest
@testable import AttributedString

final class AttributedStringTests: XCTestCase {
    
    func testBridgeFromObjectiveC() {
        let s1 = NSMutableAttributedString(string: "foo")
        let s2 = s1 as AttributedString
        s1.append(NSAttributedString(string: "bar"))
        XCTAssertEqual(s2.string, "foo")
    }
    
    func testEquity() {
        let s1 = NSAttributedString(string: "foo")
        let s2 = AttributedString("foo")
        XCTAssertEqual(s1 as AttributedString, s2)
    }

    static var allTests = [
        ("testBridgeFromObjectiveC", testBridgeFromObjectiveC),
        ("testEquity", testEquity),
    ]
}
