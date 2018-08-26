import XCTest
@testable import SwiftyJSONPatch

final class TestOperationTests: XCTestCase {
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
            {"1e0":"foo"}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/1e0","value":"foo","op":"test"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"1e0":"foo"}
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
            ["foo","bar"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/1e0","value":"bar","op":"test"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch2() {
        do {
            let docData = """
            {"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo","value":1,"spurious":1,"op":"test"}]
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
            {"foo":null}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo","value":null,"op":"test"}]
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

    func testPatch4() {
        do {
            let docData = """
            {"foo":{"bar":2,"foo":1}}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo","value":{"bar":2,"foo":1},"op":"test"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":{"bar":2,"foo":1}}
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
            {"foo":[{"bar":2,"foo":1}]}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo","value":[{"bar":2,"foo":1}],"op":"test"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":[{"bar":2,"foo":1}]}
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
            {"foo":{"bar":[1,2,5,4]}}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo","value":{"bar":[1,2,5,4]},"op":"test"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":{"bar":[1,2,5,4]}}
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
            {"foo":{"bar":[1,2,5,4]}}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo","value":[1,2],"op":"test"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch8() {
        do {
            let docData = """
            {"":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/","value":1,"op":"test"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"":1}
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
            {"":0,"c%d":2,"g|h":4,"i\\\\j":5,"a/b":1,"e^f":3,"m~n":8,"foo":["bar","baz"],"k\\"l":6," ":7}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo","value":["bar","baz"],"op":"test"},{"path":"/foo/0","value":"bar","op":"test"},{"path":"/","value":0,"op":"test"},{"path":"/a~1b","value":1,"op":"test"},{"path":"/c%d","value":2,"op":"test"},{"path":"/e^f","value":3,"op":"test"},{"path":"/g|h","value":4,"op":"test"},{"path":"/i\\\\j","value":5,"op":"test"},{"path":"/k\\"l","value":6,"op":"test"},{"path":"/ ","value":7,"op":"test"},{"path":"/m~0n","value":8,"op":"test"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"":0,"c%d":2,"g|h":4,"i\\\\j":5,"a/b":1,"e^f":3,"m~n":8,"foo":["bar","baz"],"k\\"l":6," ":7}
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

    func testPatch10() {
        do {
            let docData = """
            [null]
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"test","path":"/0"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch11() {
        do {
            let docData = """
            [false]
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"test","path":"/0"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch12() {
        do {
            let docData = """
            ["foo","bar"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/00","value":"foo","op":"test"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch13() {
        do {
            let docData = """
            ["foo","bar"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/01","value":"bar","op":"test"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch14() {
        do {
            let docData = """
            {"baz":"qux","foo":["a",2,"c"]}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/baz","value":"qux","op":"test"},{"path":"/foo/1","value":2,"op":"test"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"baz":"qux","foo":["a",2,"c"]}
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

    func testPatch15() {
        do {
            let docData = """
            {"baz":"qux"}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/baz","value":"bar","op":"test"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch16() {
        do {
            let docData = """
            {"/":9,"~1":10}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/~01","value":10,"op":"test"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"/":9,"~1":10}
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

    func testPatch17() {
        do {
            let docData = """
            {"/":9,"~1":10}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/~01","value":"10","op":"test"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch18() {
        do {
            let docData = """
            {"foo":9.3000000000000007,"bar":10}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo","value":9.3000000000000007,"op":"test"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":9.3000000000000007,"bar":10}
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
