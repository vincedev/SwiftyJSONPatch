internal enum JSONValue: Codable {
    case array([JSONValue])
    case object([String: JSONValue])
    case string(String)
    case number(Double)
    case boolean(Bool)
    case null

    enum CodingError: Error {
        case illegalValue
    }

    private enum CodingKeys: String, CodingKey {
        case array
        case dictionary
        case string
        case number
        case boolean
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let arrayValue = JSONValue.tryDecodeArray(in: container) {
            self = arrayValue
        } else if let objectValue = JSONValue.tryDecodeDictionary(in: container) {
            self = objectValue
        } else if let stringValue = JSONValue.tryDecodeString(in: container) {
            self = stringValue
        } else if let numberValue = JSONValue.tryDecodeNumber(in: container) {
            self = numberValue
        } else if let boolValue = JSONValue.tryDecodeBool(in: container) {
            self = boolValue
        } else if JSONValue.tryDecodeNull(in: container) != nil {
            self = .null
        } else {
            throw CodingError.illegalValue
        }
    }

    private static func tryDecodeArray(in container: SingleValueDecodingContainer) -> JSONValue? {
        do {
            let arrayValue = try container.decode([JSONValue].self)
            return .array(arrayValue)
        } catch {}
        return nil
    }
    private static func tryDecodeDictionary(in container: SingleValueDecodingContainer) -> JSONValue? {
        do {
            let dictionaryValue = try container.decode([String: JSONValue].self)
            return .object(dictionaryValue)
        } catch {}
        return nil
    }
    private static func tryDecodeString(in container: SingleValueDecodingContainer) -> JSONValue? {
        do {
            let stringValue = try container.decode(String.self)
            return .string(stringValue)
        } catch {}
        return nil
    }
    private static func tryDecodeNumber(in container: SingleValueDecodingContainer) -> JSONValue? {
        do {
            let doubleValue = try container.decode(Double.self)
            return .number(doubleValue)
        } catch {}
        return nil
    }
    private static func tryDecodeBool(in container: SingleValueDecodingContainer) -> JSONValue? {
        do {
            let boolValue = try container.decode(Bool.self)
            return .boolean(boolValue)
        } catch {}
        return nil
    }
    private static func tryDecodeNull(in container: SingleValueDecodingContainer) -> JSONValue? {
        return container.decodeNil() ? .null : nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .array(array):
            try container.encode(array)
        case let .object(dictionary):
            try container.encode(dictionary)
        case let .string(string):
            try container.encode(string)
        case let .number(double):
            if double.truncatingRemainder(dividingBy: 1) == 0 {
                try container.encode(Int(double))
            } else {
                try container.encode(double)
            }
        case let .boolean(boolean):
            try container.encode(boolean)
        case .null:
            try container.encodeNil()
        }
    }
}

extension JSONValue: Equatable {
    static func == (lhs: JSONValue, rhs: JSONValue) -> Bool {
        switch (lhs, rhs) {
        case (.null, .null):
            return true
        case let (.number(dbl1), .number(dbl2)):
            return dbl1 == dbl2
        case let (.boolean(bool1), .boolean(bool2)):
            return bool1 == bool2
        case let (.string(str1), .string(str2)):
            return str1 == str2
        case let (.array(arr1), .array(arr2)):
            return arr1 == arr2
        case let (.object(obj1), .object(obj2)):
            return obj1 == obj2
        default:
            return false
        }
    }
}
