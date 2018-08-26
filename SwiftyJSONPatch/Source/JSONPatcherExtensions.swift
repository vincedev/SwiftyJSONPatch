internal extension JSONPatcher {
    enum TraversalAction {
        case add(JSONValue)
        case remove
        case none
    }

    typealias JSONArray = [JSONValue]
    typealias JSONDictionary = [String: JSONValue]
    typealias TraversalHandler = (JSONValue?) throws -> TraversalAction

    internal func traverse(_ value: JSONValue,
                           to pointer: JSONPointer,
                           completion: TraversalHandler) throws -> JSONValue {
        guard !pointer.isDocument() else {
            switch try completion(value) {
            case let .add(newValue):
                return newValue
            case .remove:
                return .null
            case .none:
                return value
            }
        }

        if case let .object(object) = value {
            return try traverse(object, to: pointer, completion: completion)
        } else if case let .array(array) = value {
            return try traverse(array, to: pointer, completion: completion)
        }
        throw OperationError.notACollection
    }

    private func traverse(_ array: [JSONValue],
                          to pointer: JSONPointer,
                          completion: TraversalHandler) throws -> JSONValue {
        guard let index = pointer.index(max: array.count) else {
            throw OperationError.notAnObject
        }
        guard index >= 0 && index <= array.count else {
            throw OperationError.indexOutOfBounds(index)
        }
        var newArray = array
        guard let subpointer = pointer.subpointer() else {
            let value = index < array.count ? array[index] : nil
            var newArray = array
            switch try completion(value) {
            case let .add(newValue):
                newArray.insert(newValue, at: index)
            case .remove:
                guard index < array.count else {
                    throw OperationError.indexOutOfBounds(index)
                }
                newArray.remove(at: index)
            case .none:
                break
            }
            return .array(newArray)
        }
        guard index < array.count else {
            throw OperationError.indexOutOfBounds(index)
        }
        newArray[index] = try traverse(array[index], to: subpointer, completion: completion)
        return .array(newArray)
    }

    private func traverse(_ object: JSONDictionary,
                          to pointer: JSONPointer,
                          completion: TraversalHandler) throws -> JSONValue {
        let key = pointer.key()
        var newObject = object
        guard let subpointer = pointer.subpointer() else {
            let value = object[key]
            var newObject = object
            switch try completion(value) {
            case let .add(newValue):
                newObject[key] = newValue
            case .remove:
                guard value != nil else {
                    throw OperationError.memberNotFound(key)
                }
                newObject[key] = nil
            case .none:
                break
            }
            return .object(newObject)
        }
        guard let value = object[key] else {
            throw OperationError.memberNotFound(key)
        }
        newObject[key] = try traverse(value, to: subpointer, completion: completion)
        return .object(newObject)
    }
}

internal extension JSONPatcher {
    internal func patch(_ target: JSONValue, with operation: JSONPatchOperation) throws -> JSONValue {
        switch operation {
        case let .add(value, path):
            return try add(value: value, at: path, in: target)
        case let .remove(path):
            return try remove(at: path, in: target)
        case let .replace(path, value):
            return try replace(at: path, with: value, in: target)
        case let .test(path, value):
            return try test(at: path, against: value, in: target)
        case let .copy(from, path):
            return try copy(from: from, to: path, in: target)
        case let .move(from, path):
            return try move(from: from, to: path, in: target)
        }
    }

    private func add(value: JSONValue, at path: JSONPointer, in target: JSONValue) throws -> JSONValue {
        return try traverse(target, to: path, completion: { _ in
            return .add(value)
        })
    }

    private func remove(at path: JSONPointer, in target: JSONValue) throws -> JSONValue {
        guard case .pointer(_, _) = path else {
            return .null
        }
        return try traverse(target, to: path) { _ in
            return .remove
        }
    }

    private func replace(at path: JSONPointer, with value: JSONValue, in target: JSONValue) throws -> JSONValue {
        var newValue = try remove(at: path, in: target)
        newValue = try add(value: value, at: path, in: newValue)
        return newValue
    }

    private func copy(from: JSONPointer, to path: JSONPointer, in target: JSONValue) throws -> JSONValue {
        var valueToCopy = JSONValue.null
        _ = try traverse(target, to: from) { found in
            valueToCopy = found ?? .null
            return .none
        }
        return try add(value: valueToCopy, at: path, in: target)
    }

    internal func move(from: JSONPointer, to path: JSONPointer, in target: JSONValue) throws -> JSONValue {
        guard !path.hasPrefix(from) else {
            throw OperationError.illegalMove(from.jsonString, path.jsonString)
        }
        var valueToMove = JSONValue.null
        var value = try traverse(target, to: from) { found in
            valueToMove = found ?? .null
            return .remove
        }
        value = try add(value: valueToMove, at: path, in: value)
        return value
    }

    internal func test(at path: JSONPointer, against value: JSONValue, in target: JSONValue) throws -> JSONValue {
        return try traverse(target, to: path) { found in
            guard let found = found else {
                throw OperationError.memberNotFound("path")
            }
            guard found == value else {
                throw OperationError.testFailure
            }
            return .none
        }
    }
}
