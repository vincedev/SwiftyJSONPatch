import XCTest
@testable import SwiftyJSONPatch

final class JSONPatcherTests: XCTestCase {
    private var patcher = JSONPatcher()

    override func setUp() {
        super.setUp()
        patcher = JSONPatcher()
    }

    func testInvalidJSONDocumentGivenToPatcher() {
        do {
            _ = try patcher.apply("""
                [ { "op": "replace", "path": "/0", "value": "baz" } ]
            """.data(using: .utf8)!, on: "bar".data(using: .utf8)!)
            XCTFail("Patcher should have thrown an error")
        } catch JSONPatcher.PatchingError.document {} catch {
            XCTFail("Patcher should have thrown JSONPatcher.PatchingError.document. Got \(error) instead.")
        }
    }

    func testInvalidJSONPatchGivenToPatcher() {
        do {
            _ = try patcher.apply("""
                [ { "op": 42, "path": "/0", "value": "baz" } ]
            """.data(using: .utf8)!, on: """
                ["bar"]
            """.data(using: .utf8)!)
            XCTFail("Patcher should have thrown an error")
        } catch JSONPatcher.PatchingError.patch {} catch {
            XCTFail("Patcher should have thrown JSONPatcher.PatchingError.patch. Got \(error) instead.")
        }
    }
}
