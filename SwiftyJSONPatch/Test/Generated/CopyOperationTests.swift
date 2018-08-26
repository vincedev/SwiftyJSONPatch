import XCTest
@testable import SwiftyJSONPatch

final class CopyOperationTests: XCTestCase {
    private var patcher = JSONPatcher()
    private var decoder = JSONDecoder()

    override func setUp() {
        super.setUp()
        patcher = JSONPatcher()
        decoder = JSONDecoder()
    }

    func testPatch0() {
        do {
            let docData = """
            {"foo":null}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"copy","path":"/bar","from":"/foo"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"bar":null,"foo":null}
            """.data(using: .utf8)!
            let patchedData = try patcher.apply(patchData, on: docData)

            let expectedValue = try decoder.decode(JSONValue.self, from: expectedData)
            let patchedValue = try decoder.decode(JSONValue.self, from: patchedData)
            XCTAssertEqual(patchedValue, expectedValue)
        }
        catch {
            XCTFail("Test should not throw an error: \(error)")
        }
    }

    func testPatch1() {
        do {
            let docData = """
            {"baz":[{"qux":"hello"}],"bar":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"copy","path":"/boo","from":"/baz/0"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"baz":[{"qux":"hello"}],"bar":1,"boo":{"qux":"hello"}}
            """.data(using: .utf8)!
            let patchedData = try patcher.apply(patchData, on: docData)

            let expectedValue = try decoder.decode(JSONValue.self, from: expectedData)
            let patchedValue = try decoder.decode(JSONValue.self, from: patchedData)
            XCTAssertEqual(patchedValue, expectedValue)
        }
        catch {
            XCTFail("Test should not throw an error: \(error)")
        }
    }

    func testPatch2() {
        do {
            let docData = """
            {"baz":[1,2,3],"bar":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"copy","path":"/boo","from":"/baz/1e0"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch3() {
        do {
            let docData = """
            [1]
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"copy","path":"/-"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

}
