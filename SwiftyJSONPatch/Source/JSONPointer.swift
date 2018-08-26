indirect internal enum JSONPointer {
    enum PointerStringError: Error {
        case invalid(String)
    }

    case document
    case pointer(String, JSONPointer?)

    init(_ string: String) throws {
        guard string.count == 0 || string.hasPrefix("/") else {
            throw PointerStringError.invalid(string)
        }
        guard string.count > 0 else {
            self = .document
            return
        }
        guard string.count > 1 else {
            self = .pointer("", nil)
            return
        }
        self = try JSONPointer.jsonPointer(from: string)
    }

    var jsonString: String {
        switch self {
        case .document:
            return ""
        case let .pointer(element, pointer):
            return "/" + element + (pointer?.jsonString ?? "")
        }
    }

    func isDocument() -> Bool {
        switch self {
        case .document:
            return true
        default:
            return false
        }
    }

    func key() -> String {
        switch self {
        case .document:
            return ""
        case let .pointer(element, _):
            let key = element
                .replacingOccurrences(of: "~1", with: "/")
                .replacingOccurrences(of: "~0", with: "~")
            return key
        }
    }

    func index(max: Int) -> Int? {
        switch self {
        case .document:
            return nil
        case let .pointer(element, _):
            guard element != "-" else {
                return max
            }
            guard (!element.hasPrefix("0") || element == "0"), let index = Int(element) else {
                return nil
            }
            return index
        }
    }

    func subpointer() -> JSONPointer? {
        switch self {
        case let .pointer(_, subpointer):
            return subpointer
        default:
            return nil
        }
    }

    func hasPrefix(_ prefix: JSONPointer) -> Bool {
        switch (self, prefix) {
        case (.document, .document),
             (.document, .pointer),
             (.pointer, .document),
             (.pointer(_, nil), .pointer(_, nil)),
             (.pointer, .pointer(_, nil)):
            return false
        case let (.pointer(element1, nil), .pointer(element2, _)):
            return element1 == element2
        case let (.pointer(_, .some(subpointer)), .pointer(_, .some(subprefix))):
            return subprefix.hasPrefix(subpointer)
        }
    }

    private static func jsonPointer(from string: String) throws -> JSONPointer {
        var substring = string
        substring.removeFirst()
        let splitted = JSONPointer.split(string: substring)
        guard let remaining = splitted.1 else {
            return .pointer(splitted.0, nil)
        }
        return try .pointer(splitted.0, JSONPointer(remaining))
    }

    private static func split(string: String) -> (String, String?) {
        guard let slashIndex = string.index(of: "/") else {
            return (string, nil)
        }
        let element = String(string.prefix(upTo: slashIndex))
        return (element, String(string.suffix(from: slashIndex)))
    }
}
