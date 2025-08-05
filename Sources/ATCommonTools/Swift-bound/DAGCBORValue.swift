//
//  DAGCBORValue.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-07-05.
//

import Foundation
import MultiformatsKit

/// An enumeration describing a value encoded using the DAG-CBOR data model.
///
/// This specific model is desgined specifically for the AT Protocol. The use of floats is strictly
/// prohibited in DAG-CBOR values while in an AT Protocol service.
public enum DAGCBORValue: Codable, Equatable, Hashable {

    /// A UTF-8 encoded string value.
    case string(String)

    /// An integer number value.
    case int(Int)

    /// A boolean value.
    case bool(Bool)

    /// A null value.
    case `nil`

    /// A CID value to another DAG-CBOR object.
    case cid(CID)

    /// An object represented as a map from strings to DAG-CBOR values.
    case dictionary([String: DAGCBORValue])

    /// An array of DAG-CBOR values.
    case array([DAGCBORValue])

    /// A raw sequence of bytes.
    case data(Data)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .nil
            return
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
            return
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
            return
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
            return
        } else if let value = try? container.decode([DAGCBORValue].self) {
            self = .array(value)
            return
        } else if let value = try? container.decode([String: DAGCBORValue].self) {
            self = .dictionary(value)
            return
        } else if let value = try? container.decode(Data.self) {
            self = .data(value)
            return
        } else if let value = try? container.decode(CID.self) {
            self = .cid(value)
            return
        } else {
            throw Swift.DecodingError.typeMismatch(
                DAGCBORValue.self,
                Swift.DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unrecognized DAG-CBOR value"
                )
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .string(let value):
                try container.encode(value)
            case .int(let value):
                try container.encode(value)
            case .bool(let value):
                try container.encode(value)
            case .nil:
                try container.encodeNil()
            case .cid(let value):
                try container.encode(value)
            case .dictionary(let value):
                try container.encode(value)
            case .array(let value):
                try container.encode(value)
            case .data(let value):
                try container.encode(value)
        }
    }
}
