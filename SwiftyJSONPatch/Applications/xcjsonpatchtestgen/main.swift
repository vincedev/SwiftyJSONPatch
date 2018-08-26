import Foundation

func valueString(_ value: JSONValue) -> String {
    do {
        let encoder = JSONEncoder()
        return try
            String(data: encoder.encode(value),
                   encoding: .utf8)?
                .replacingOccurrences(of: "\\/", with: "/")
                .replacingOccurrences(of: "\\", with: "\\\\") ?? ""
    } catch {
        return ""
    }
}

func successTestString(name: String, document: String, patch: String, expected: String) -> String {
    return """

        func test\(name)() {
            do {
                let docData = \"\"\"
                \(document)
                \"\"\".data(using: .utf8)!
                let patchData = \"\"\"
                \(patch)
                \"\"\".data(using: .utf8)!
                let expectedData = \"\"\"
                \(expected)
                \"\"\".data(using: .utf8)!
                let patchedData = try patcher.apply(patchData, on: docData)

                let expectedValue = try decoder.decode(JSONValue.self, from: expectedData)
                let patchedValue = try decoder.decode(JSONValue.self, from: patchedData)
                XCTAssertEqual(patchedValue, expectedValue)
            }
            catch {
                XCTFail("Test should not throw an error: \\(error)")
            }
        }

    """
}

func failureTestString(name: String, document: String, patch: String, error: String) -> String {
    return """

        func test\(name)() {
            do {
                let docData = \"\"\"
                \(document)
                \"\"\".data(using: .utf8)!
                let patchData = \"\"\"
                \(patch)
                \"\"\".data(using: .utf8)!
                _ = try patcher.apply(patchData, on: docData)
                XCTFail("Test should throw an error.")
            }
            catch {}
        }

    """
}

func headerTestString(name: String) -> String {
    return """
    import XCTest
    @testable import SwiftyJSONPatch

    final class \(name): XCTestCase {
        private var patcher = JSONPatcher()
        private var decoder = JSONDecoder()

        override func setUp() {
            super.setUp()
            patcher = JSONPatcher()
            decoder = JSONDecoder()
        }

    """
}

func footerTestString() -> String {
    return """

    }

    """
}

func listJSONFiles(in url: URL) throws -> [URL] {
    return try FileManager
        .default
        .contentsOfDirectory(at: url, includingPropertiesForKeys: nil,
                             options: [
                                .skipsHiddenFiles,
                                .skipsPackageDescendants,
                                .skipsSubdirectoryDescendants])
        .filter {
            return $0.pathExtension == "json"
        }
}

func testString(with test: JSONValue, name: String) -> String? {
    guard case let .object(object) = test, let doc = object["doc"], let patch = object["patch"] else {
        return nil
    }
    if let disabled = object["disabled"], case let .boolean(disabledTest) = disabled, disabledTest {
        return nil
    } else if let error = object["error"], case let .string(errorString) = error {
        return failureTestString(name: name, document: valueString(doc), patch: valueString(patch), error: errorString)
    } else {
        let expected = object["expected"] ?? doc
        return successTestString(name: name, document: valueString(doc), patch: valueString(patch), expected: valueString(expected))
    }
}

func testString(with file: URL, className: String) throws -> String {
    let decoder = JSONDecoder()
    let testsData = try Data(contentsOf: file)
    let tests = try decoder.decode([JSONValue].self, from: testsData)
    var testsFileString = headerTestString(name: className)
    var testIndex = 0
    for test in tests {
        if let testString = testString(with: test, name: "Patch\(testIndex)") {
            testsFileString += testString
            testIndex += 1
        }
    }
    testsFileString += footerTestString()
    return testsFileString
}

func writeTestString(_ string: String, to url: URL, className: String) throws {
    let dstFile = url.appendingPathComponent(className + ".swift")
    do { try FileManager.default.removeItem(at: dstFile) } catch {}
    do { try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil) } catch {}
    try string.write(to: dstFile, atomically: true, encoding: .utf8)
}

let args = CommandLine.arguments
guard args.count > 2 else {
    exit(1)
}

let srcDir = URL(fileURLWithPath: args[1])
let dstDir = URL(fileURLWithPath: args[2])
do {
    let files = try listJSONFiles(in: srcDir)
    for file in files {
        let testsClassName = file.deletingPathExtension()
            .lastPathComponent
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
            .replacingOccurrences(of: " ", with: "")
        let testsFileString = try testString(with: file, className: testsClassName)
        try writeTestString(testsFileString, to: dstDir, className: testsClassName)
    }
} catch {
    print("\(error)")
    exit(1)
}

exit(0)
