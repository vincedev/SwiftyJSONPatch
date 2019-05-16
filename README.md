SwiftyJSONPatch
===============

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A Swift 5 implementation for IETF JSON-patch ([RFC 6902](http://tools.ietf.org/html/rfc6902)).  
iOS 8+  
macOS 10.9+

# Features

SwiftyJSONPatch defines `JSONPatcher` value type.  
`JSONPatcher` applies JSON-patches to JSON documents.

## Patching

```swift
import SwiftyJSONPatch

let json = """
  { "foo": 1, "bar": "baz", "baz": null }
""".data(using: .utf8)!

let patch = """
  [
    { "op": "test", "value": "baz", "path": "/bar" },
    { "op": "remove", "path": "/baz" },
    { "op": "add", "path": "/toto", "value": [1, 2, 3] },
    { "op": "replace", "path": "/toto/2", "value": "baz" },
    { "op": "copy", "from": "/foo", "path": "/toto/0" },
    { "op": "move", "from": "/bar", "path": "/foo" },
  ]
""".data(using: .utf8)!

let patcher = JSONPatcher()
do {
    let patched = try patcher.apply(patch, on: json)
    if let result = String(data: patched, encoding: .utf8) {
        print(result) // {"foo":"baz","toto":[1,1,2,"baz"]}
    }
} catch {
    print("Error: \(error)")
}
```

## Error Handling

The `JSONPatcher.PatchingError` enum represents error cases `JSONPatcher` may throw while applying a patch :

```swift
public enum PatchingError: Error {
    case document(Error)                    // failed to decode document JSON data
    case patch(Error)                       // failed to decode patch JSON data
    case operation(String, OperationError)  // failed to apply specific patch operation
}
```
The associated values gives you details about what have gone wrong.
The `JSONPatcher.OperationError` describes error cases while trying to perform patch operations :

```swift
public enum OperationError: Error {
    case indexOutOfBounds(Int)          // index out of bounds (index)
    case memberNotFound(String)         // member not found (name)
    case notACollection                 // neither an array, nor an object
    case notAnObject                    // not an object
    case testFailure                    // test operation failed
    case illegalMove(String, String)    // wrong paths in move operation (from, path)
}
```

# Getting Started

## Installation

### Carthage

Add `github "vincedev/SwiftyJSONPatch"` to your Cartfile.

### Building SwiftyJSONPatch

You'll need [SwiftLint](https://github.com/realm/SwiftLint) to build the framework from source.  
Clone the repository, open `SwiftyJSONPatch.xworkspace`.  
Build the target for your preferred platform.

## Getting Help

[Open an issue](https://github.com/vincedev/SwiftyJSONPatch/issues) if you have found a bug, or have a feature request.


## 
