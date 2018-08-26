import XCTest
@testable import SwiftyJSONPatch

final class MoveOperationTests: XCTestCase {
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
            {"qux":{"corge":"grault"},"foo":{"waldo":"fred","bar":"baz"}}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"move","path":"/qux/thud","from":"/foo/waldo"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"qux":{"corge":"grault","thud":"fred"},"foo":{"bar":"baz"}}
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
            {"foo":["all","grass","cows","eat"]}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"move","path":"/foo/3","from":"/foo/1"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":["all","cows","eat","grass"]}
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
            {"foo":null}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"move","path":"/bar","from":"/foo"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"bar":null}
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

    func testPatch3() {
        do {
            let docData = """
            {"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"move","path":"/foo","from":"/foo"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":1}
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

    func testPatch4() {
        do {
            let docData = """
            {"baz":[{"qux":"hello"}],"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"move","path":"/bar","from":"/foo"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"baz":[{"qux":"hello"}],"bar":1}
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

    func testPatch5() {
        do {
            let docData = """
            {"baz":[{"qux":"hello"}],"bar":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"move","path":"/baz/1","from":"/baz/0/qux"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"baz":[{},"hello"],"bar":1}
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

    func testPatch6() {
        do {
            let docData = """
            {"baz":[1,2,3,4],"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"move","path":"/foo","from":"/baz/1e0"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch7() {
        do {
            let docData = """
            {"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"move","path":""}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

}
