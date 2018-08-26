internal enum JSONPatchOperation: Codable, CustomStringConvertible {
    case add(value: JSONValue, path: JSONPointer)
    case remove(path: JSONPointer)
    case replace(path: JSONPointer, value: JSONValue)
    case move(from: JSONPointer, path: JSONPointer)
    case copy(from: JSONPointer, path: JSONPointer)
    case test(path: JSONPointer, value: JSONValue)

    enum CodingError: Error {
        case illegalOperation(String)
    }

    enum CodingKeys: String, CodingKey {
        case operation = "op"
        case from
        case path
        case value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let operation = try container.decode(String.self, forKey: .operation)
        let path = try container.decode(String.self, forKey: .path)
        switch operation {
        case "add":
            let value = try container.decode(JSONValue.self, forKey: .value)
            self = try .add(value: value, path: JSONPointer(path))
        case "remove":
            self = try .remove(path: JSONPointer(path))
        case "replace":
            let value = try container.decode(JSONValue.self, forKey: .value)
            self = try .replace(path: JSONPointer(path), value: value)
        case "move":
            let from = try container.decode(String.self, forKey: .from)
            self = try .move(from: JSONPointer(from), path: JSONPointer(path))
        case "copy":
            let from = try container.decode(String.self, forKey: .from)
            self = try .copy(from: JSONPointer(from), path: JSONPointer(path))
        case "test":
            let value = try container.decode(JSONValue.self, forKey: .value)
            self = try .test(path: JSONPointer(path), value: value)
        default:
            throw CodingError.illegalOperation(operation)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .add(value, path):
            try container.encode("add", forKey: .operation)
            try container.encode(value, forKey: .value)
            try container.encode(path.jsonString, forKey: .path)
        case let .remove(path):
            try container.encode("remove", forKey: .operation)
            try container.encode(path.jsonString, forKey: .path)
        case let .replace(path, value):
            try container.encode("replace", forKey: .operation)
            try container.encode(value, forKey: .value)
            try container.encode(path.jsonString, forKey: .path)
        case let .move(from, path):
            try container.encode("move", forKey: .operation)
            try container.encode(path.jsonString, forKey: .path)
            try container.encode(from.jsonString, forKey: .from)
        case let .copy(from, path):
            try container.encode("copy", forKey: .operation)
            try container.encode(path.jsonString, forKey: .path)
            try container.encode(from.jsonString, forKey: .from)
        case let .test(path, value):
            try container.encode("test", forKey: .operation)
            try container.encode(path.jsonString, forKey: .path)
            try container.encode(value, forKey: .value)
        }
    }

    var description: String {
        let encoder = JSONEncoder()
        do {
            return try String(data: encoder.encode(self), encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
}
