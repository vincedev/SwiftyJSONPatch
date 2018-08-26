import XCTest
@testable import SwiftyJSONPatch

final class RemoveOperationTests: XCTestCase {
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
            {"baz":"qux","foo":"bar"}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"remove","path":"/baz"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":"bar"}
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
            {"foo":["bar","qux","baz"]}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"remove","path":"/foo/1"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":["bar","baz"]}
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
            {"bar":[1,2,3,4],"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"remove","path":"/bar"}]
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

    func testPatch3() {
        do {
            let docData = """
            {"baz":[{"qux":"hello"}],"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"remove","path":"/baz/0/qux"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"baz":[{}],"foo":1}
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
            {"foo":null}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"remove","path":"/foo"}]
            """.data(using: .utf8)!
            let expectedData = """
            {}
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
            {"baz":[{"qux":"hello"}],"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"remove","path":"/baz/1e0/qux"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch6() {
        do {
            let docData = """
            [1,2,3,4]
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"remove","path":"/0"}]
            """.data(using: .utf8)!
            let expectedData = """
            [2,3,4]
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

    func testPatch7() {
        do {
            let docData = """
            [1,2,3,4]
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"remove","path":"/1"},{"op":"remove","path":"/2"}]
            """.data(using: .utf8)!
            let expectedData = """
            [1,3]
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

    func testPatch8() {
        do {
            let docData = """
            [1,2,3,4]
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"remove","path":"/1e0"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch9() {
        do {
            let docData = """
            {"foo":"bar"}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"remove","path":"/baz"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch10() {
        do {
            let docData = """
            ["foo","bar"]
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"remove","path":"/2"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch11() {
        do {
            let docData = """
            []
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"remove","path":""}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

}
