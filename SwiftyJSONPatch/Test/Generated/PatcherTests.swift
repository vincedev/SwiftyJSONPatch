import XCTest
@testable import SwiftyJSONPatch

final class PatcherTests: XCTestCase {
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
            ["bar"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/0","value":"baz","op":"replace"}]
            """.data(using: .utf8)!
            let expectedData = """
            ["baz"]
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
            ["bar"]
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"remove","path":"/0"}]
            """.data(using: .utf8)!
            let expectedData = """
            []
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
            [{"bar":[{"foo":[{"baz":1}]}]}]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/0/bar/0/foo/0/baz","value":"baz","op":"remove"}]
            """.data(using: .utf8)!
            let expectedData = """
            [{"bar":[{"foo":[{}]}]}]
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
            ["bar"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/0","value":"bar","op":"test"}]
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

    func testPatch4() {
        do {
            let docData = """
            {"foo":"bar"}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/bar","value":"bar","op":"test"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch5() {
        do {
            let docData = """
            {"baz":null,"bar":"baz","foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/bar","value":"baz","op":"test"},{"op":"remove","path":"/baz"},{"path":"/toto","value":[1,2,3],"op":"add"},{"path":"/toto/2","value":"baz","op":"replace"},{"op":"copy","path":"/toto/0","from":"/foo"},{"op":"move","path":"/foo","from":"/bar"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":"baz","toto":[1,1,2,"baz"]}
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
            {}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"","value":{},"op":"test"}]
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

    func testPatch7() {
        do {
            let docData = """
            [1]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/0","value":"baz","op":"test"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch8() {
        do {
            let docData = """
            [1]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"baz","value":"baz","op":"test"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch9() {
        do {
            let docData = """
            []
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"","value":"{}","op":"test"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch10() {
        do {
            let docData = """
            {"foo":{"bar":{"baz":"toto"}}}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"move","path":"/foo/bar/baz","from":"/foo/bar"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch11() {
        do {
            let docData = """
            {"foo":{"bar":{"baz":"toto"}}}
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"move","path":"/foo/bar","from":"/foo/baz"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch12() {
        do {
            let docData = """
            [1.234,1,1,1,1]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/10","value":1,"op":"add"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch13() {
        do {
            let docData = """
            []
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/","value":1,"op":"toto"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

}
