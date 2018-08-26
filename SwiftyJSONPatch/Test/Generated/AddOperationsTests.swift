import XCTest
@testable import SwiftyJSONPatch

final class AddOperationsTests: XCTestCase {
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
            [{"path":"/foo","value":1,"op":"add"}]
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

    func testPatch1() {
        do {
            let docData = """
            []
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/0","value":"foo","op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            ["foo"]
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
            {}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo","value":"1","op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":"1"}
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
            {}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo","value":1,"op":"add"}]
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
            {}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"","value":[],"op":"add"}]
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

    func testPatch5() {
        do {
            let docData = """
            []
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"","value":{},"op":"add"}]
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

    func testPatch6() {
        do {
            let docData = """
            []
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/-","value":"hi","op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            ["hi"]
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
            {}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/","value":1,"op":"add"}]
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

    func testPatch8() {
        do {
            let docData = """
            {"foo":{}}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo/","value":1,"op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":{"":1}}
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
            {"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/bar","value":[1,2],"op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"bar":[1,2],"foo":1}
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
            {"baz":[{"qux":"hello"}],"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/baz/0/foo","value":"world","op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"baz":[{"qux":"hello","foo":"world"}],"foo":1}
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
            {"bar":[1,2]}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/bar/8","value":"5","op":"add"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch12() {
        do {
            let docData = """
            {"bar":[1,2]}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/bar/-1","value":"5","op":"add"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch13() {
        do {
            let docData = """
            {"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/bar","value":true,"op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"bar":true,"foo":1}
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

    func testPatch14() {
        do {
            let docData = """
            {"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/bar","value":false,"op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"bar":false,"foo":1}
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
            {"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/bar","value":null,"op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"bar":null,"foo":1}
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

    func testPatch16() {
        do {
            let docData = """
            {"foo":1}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/0","value":"bar","op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"0":"bar","foo":1}
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
            ["foo"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/1","value":"bar","op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            ["foo","bar"]
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

    func testPatch18() {
        do {
            let docData = """
            ["foo","sil"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/1","value":"bar","op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            ["foo","bar","sil"]
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

    func testPatch19() {
        do {
            let docData = """
            ["foo","sil"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/0","value":"bar","op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            ["bar","foo","sil"]
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

    func testPatch20() {
        do {
            let docData = """
            ["foo","sil"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/2","value":"bar","op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            ["foo","sil","bar"]
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

    func testPatch21() {
        do {
            let docData = """
            ["foo","sil"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/3","value":"bar","op":"add"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch22() {
        do {
            let docData = """
            ["foo","sil"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/bar","value":42,"op":"add"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch23() {
        do {
            let docData = """
            ["foo","sil"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/1","value":["bar","baz"],"op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            ["foo",["bar","baz"],"sil"]
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

    func testPatch24() {
        do {
            let docData = """
            {"foo":"bar"}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"","value":{"baz":"qux"},"op":"add"}]
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

    func testPatch25() {
        do {
            let docData = """
            [1,2]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/-","value":{"foo":["bar","baz"]},"op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            [1,2,{"foo":["bar","baz"]}]
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

    func testPatch26() {
        do {
            let docData = """
            [1,2,[3,[4,5]]]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/2/1/-","value":{"foo":["bar","baz"]},"op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            [1,2,[3,[4,5,{"foo":["bar","baz"]}]]]
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

    func testPatch27() {
        do {
            let docData = """
            ["foo","sil"]
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/1e0","value":"bar","op":"add"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch28() {
        do {
            let docData = """
            [1]
            """.data(using: .utf8)!
            let patchData = """
            [{"op":"add","path":"/-"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch29() {
        do {
            let docData = """
            {"foo":"bar"}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/FOO","value":"BAR","op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"FOO":"BAR","foo":"bar"}
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

    func testPatch30() {
        do {
            let docData = """
            {"q":{"bar":2}}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/a/b","value":1,"op":"add"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch31() {
        do {
            let docData = """
            {"foo":"bar"}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/baz","value":"qux","op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"baz":"qux","foo":"bar"}
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

    func testPatch32() {
        do {
            let docData = """
            {"foo":["bar","baz"]}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo/1","value":"qux","op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":["bar","qux","baz"]}
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

    func testPatch33() {
        do {
            let docData = """
            {"foo":"bar"}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/child","value":{"grandchild":{}},"op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"child":{"grandchild":{}},"foo":"bar"}
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

    func testPatch34() {
        do {
            let docData = """
            {"foo":"bar"}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/baz","value":"qux","op":"add","xyz":123}]
            """.data(using: .utf8)!
            let expectedData = """
            {"baz":"qux","foo":"bar"}
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

    func testPatch35() {
        do {
            let docData = """
            {"foo":"bar"}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/baz/bat","value":"qux","op":"add"}]
            """.data(using: .utf8)!
            _ = try patcher.apply(patchData, on: docData)
            XCTFail("Test should throw an error.")
        }
        catch {}
    }

    func testPatch36() {
        do {
            let docData = """
            {"foo":["bar"]}
            """.data(using: .utf8)!
            let patchData = """
            [{"path":"/foo/-","value":["abc","def"],"op":"add"}]
            """.data(using: .utf8)!
            let expectedData = """
            {"foo":["bar",["abc","def"]]}
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
