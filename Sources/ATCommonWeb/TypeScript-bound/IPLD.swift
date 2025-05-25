//
//  IPLD.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-03-18.
//

import Foundation
import MultiformatsKit

/// A namespace contains types and utilities for working with IPLD (InterPlanetary Linked Data) values,
/// which are used to represent and encode arbitrary, self-describing, content-addressable data.
public enum IPLD: Equatable {

    /// A type-safe and thread-safe representation of JSON-compatible values, used for encoding and decoding
    /// arbitrary JSON data.
    public enum JSONValue: Codable, Equatable, Hashable {

        /// A `String` object.
        case string(String)

        /// A `Double` object.
        case number(Int)

        /// A `Bool` value.
        case bool(Bool)

        /// A `nil` value.
        case `nil`

        /// An `Array` of `JSONValue` objects.
        case array([JSONValue])

        /// A `Dictionary` object, with `JSONValue` as the value.
        case dictionary([String: JSONValue])

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if container.decodeNil() {
                self = .nil
            } else if let bool = try? container.decode(Bool.self) {
                self = .bool(bool)
            } else if let number = try? container.decode(Int.self) {
                self = .number(number)
            } else if let string = try? container.decode(String.self) {
                self = .string(string)
            } else if let array = try? container.decode([JSONValue].self) {
                self = .array(array)
            } else if let object = try? container.decode([String: JSONValue].self) {
                self = .dictionary(object)
            } else {
                throw Swift.DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSON value")
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .string(let value):
                    try container.encode(value)
                case .number(let value):
                    try container.encode(value)
                case .bool(let value):
                    try container.encode(value)
                case .nil:
                    try container.encodeNil()
                case .array(let value):
                    try container.encode(value)
                case .dictionary(let value):
                    try container.encode(value)
            }
        }
    }

    /// An enum representing all valid IPLD (InterPlanetary Linked Data) values.
    public enum IPLDValue: Codable, Equatable, Hashable {

        /// A `JSONValue` object.
        case jsonValue(JSONValue)

        /// A `CID` object.
        case cid(CID)

        /// A `Data` object.
        case bytes(Data)

        /// An array of `IPLDValue` objects.
        case array([IPLDValue])

        /// A `Dictionary` object, with `IPLDValue` as the value.
        case dictionary([String: IPLDValue])

        public init(from decoder: Decoder) throws {
            // Decode as JSONValue, then use the adapter to make IPLDValue.
            let jsonValue = try JSONValue(from: decoder)
            self = IPLD.jsonToIPLD(jsonValue)
        }

        public func encode(to encoder: Encoder) throws {
            // Convert self to JSONValue, then encode.
            let jsonValue = IPLD.ipldToJSON(self)
            try jsonValue.encode(to: encoder)
        }
    }

    /// Converts a `JSONValue` to `IPLDValue`.
    ///
    /// - Parameter value: A `JSONValue` object.
    /// - Returns: An `IPLDValue` object.
    public static func jsonToIPLD(_ value: JSONValue) -> IPLDValue {
        switch value {
            case .array(let array):
                return .array(array.map { jsonToIPLD($0) })
            case .dictionary(let dictionary):
                // Special case for { "$link": "..." }
                if dictionary.count == 1, let jsonValue = dictionary["$link"], case let .string(linkString) = jsonValue {
                    if let cid = try? CID(string: linkString) {
                        return .cid(cid)
                    }
                }

                // Special case for { "$bytes": "..." }
                if dictionary.count == 1, let jsonValue = dictionary["$bytes"], case let .string(bytesString) = jsonValue {
                    if let data = Data(base64Encoded: bytesString) {
                        return .bytes(data)
                    }
                }

                // Plain object: recursively convert each value.
                var newDictionary: [String: IPLDValue] = [:]
                for (key, value) in dictionary {
                    newDictionary[key] = jsonToIPLD(value)
                }

                return .dictionary(newDictionary)
            case .string(let value):
                return .jsonValue(.string(value))
            case .number(let value):
                return .jsonValue(.number(value))
            case .bool(let value):
                return .jsonValue(.bool(value))
            case .nil:
                return .jsonValue(.nil)
        }
    }

    /// Converts an `IPLDValue` to `JSONValue`.
    ///
    /// - Parameter value: A `IPLDValue` object.
    /// - Returns: A `JSONValue` object.
    public static func ipldToJSON(_ value: IPLDValue) -> JSONValue {
        switch value {
            case .array(let array):
                return .array(array.map { ipldToJSON($0) })
            case .dictionary(let dictionary):
                var newDictionary: [String: JSONValue] = [:]
                for (key, value) in dictionary {
                    newDictionary[key] = ipldToJSON(value)
                }

                return .dictionary(newDictionary)
            case .cid(let cid):
                return .dictionary([
                    "$link": .string((try? cid.encode()) ?? "")
                ])
            case .bytes(let data):
                return .dictionary([
                    "$bytes": .string(data.base64EncodedString())
                ])
            case .jsonValue(let json):
                return json
        }
    }
}
