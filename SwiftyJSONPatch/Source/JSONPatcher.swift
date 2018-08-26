public struct JSONPatcher {
    public enum PatchingError: Error {
        case document(Error)
        case patch(Error)
        case operation(String, OperationError)
    }

    public enum OperationError: Error {
        case indexOutOfBounds(Int)
        case memberNotFound(String)
        case notACollection
        case notAnObject
        case testFailure
        case illegalMove(String, String)
    }

    public init() {}

    public func apply(_ data: Data, on target: Data) throws -> Data {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        var value = JSONValue.null
        var patch = [JSONPatchOperation]()

        do {
            value = try decoder.decode(JSONValue.self, from: target)
        } catch {
            throw PatchingError.document(error)
        }

        do {
            patch = try decoder.decode([JSONPatchOperation].self, from: data)
        } catch {
            throw PatchingError.patch(error)
        }

        var operation = ""
        do {
            for patchOperation in patch {
                operation = patchOperation.description
                value = try self.patch(value, with: patchOperation)
            }
            return try encoder.encode(value)
        } catch let error as OperationError {
            throw PatchingError.operation(
                operation,
                error
            )
        }
    }
}
