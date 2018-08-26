import XCTest
@testable import SwiftyJSONPatch

final class JSONPointerTests: XCTestCase {
    func testGetDocumentSubpointer() {
        XCTAssertNil(JSONPointer.document.subpointer())
    }

    func testGetDocumentIndex() {
        XCTAssertNil(JSONPointer.document.index(max: 10))
    }

    func testGetDocumentKey() {
        XCTAssertEqual(JSONPointer.document.key(), "")
    }
}
