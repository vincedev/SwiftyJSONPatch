import XCTest
@testable import SwiftyJSONPatch

final class ReplaceOperationTests: XCTestCase {
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
            {"baz":[{"qux":"hello"}],"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo","value":[1,2,3,4],"op":"replace"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"baz":[{"qux":"hello"}],"foo":[1,2,3,4]}
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
            {"baz":[{"qux":"hello"}],"foo":[1,2,3,4]}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/baz/0/qux","value":"world","op":"replace"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"baz":[{"qux":"world"}],"foo":[1,2,3,4]}
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
            ["foo"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/0","value":"bar","op":"replace"}]
            """.data(using: .utf8)!
            let expectedData = """
            ["bar"]
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
            [""]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/0","value":0,"op":"replace"}]
            """.data(using: .utf8)!
            let expectedData = """
            [0]
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
            [""]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/0","value":true,"op":"replace"}]
            """.data(using: .utf8)!
            let expectedData = """
            [true]
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
            [""]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/0","value":false,"op":"replace"}]
            """.data(using: .utf8)!
            let expectedData = """
            [false]
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
            [""]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/0","value":null,"op":"replace"}]
            """.data(using: .utf8)!
            let expectedData = """
            [null]
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
            ["foo","sil"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/1","value":["bar","baz"],"op":"replace"}]
            """.data(using: .utf8)!
            let expectedData = """
            ["foo",["bar","baz"]]
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
            {"foo":"bar"}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"","value":{"baz":"qux"},"op":"replace"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"baz":"qux"}
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

    func testPatch9() {
        do {
            let docData = """
            {"bar":"baz"}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo/bar","value":false,"op":"replace"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch10() {
        do {
            let docData = """
            {"foo":null}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo","value":"truthy","op":"replace"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":"truthy"}
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

    func testPatch11() {
        do {
            let docData = """
            {"foo":"bar"}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo","value":null,"op":"replace"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":null}
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

    func testPatch12() {
        do {
            let docData = """
            [""]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/1e0","value":false,"op":"replace"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch13() {
        do {
            let docData = """
            [1]
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"replace","path":"/0"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch14() {
        do {
            let docData = """
            {"baz":"qux","foo":"bar"}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/baz","value":"boo","op":"replace"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"baz":"boo","foo":"bar"}
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

}
