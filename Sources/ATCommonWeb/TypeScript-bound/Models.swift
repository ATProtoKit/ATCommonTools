//
//  Models.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-05-10.
//

import Foundation
import MultiformatsKit

/// A structure related to Content Addressable aRchive (CAR) headers.
public struct CARHeader: Codable {

    /// The version number for the CAR file.
    ///
    /// It will always be `1` at this time.
    public let version: Int

    /// An array of CID roots.
    public let roots: [CID]

    public init(roots: [CID]) {
        self.version = 1
        self.roots = roots
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let version = try container.decode(Int.self, forKey: .version)
        guard version == 1 else {
            throw DecodingError.dataCorruptedError(forKey: .version, in: container, debugDescription: "CAR version must be 1")
        }
        self.version = version
        self.roots = try container.decode([CID].self, forKey: .roots)
    }
}

/// A protocol that defines a generic schema for validating data.
import Foundation

/// An enum to represent different schema types.
public enum SchemaType {

    /// Represents a schema for validating `String` values.
    case string

    /// Represents a schema for validating `Data` values.
    case data

    /// Represents a schema for validating `CID` values.
    case cid

    /// Represents a schema for validating `CARHeader` values
    case carHeader

    /// Represents a schema for validating `[String: UnknownType` values.
    case array

    /// Represents a schema for validating `UnknownType` values.
    case unknown

    /// Returns a human-readable name for the schema.
    var name: String {
        switch self {
            case .string:
                return "string"
            case .data:
                return "bytes"
            case .cid:
                return "cid"
            case .carHeader:
                return "CAR header"
            case .array:
                return "map"
            case .unknown:
                return "unknown"
        }
    }

    /// Validates a value based on the schema type.
    ///
    /// - Parameter value: The value to validate against the schema.
    /// - Returns: `true` if the schema is valid, or `false` if it isn't.
    func validate(_ value: Any) -> Bool {
        switch self {
            case .string:
                return value is String
            case .data:
                return value is Data
            case .cid:
                return value is CID
            case .carHeader:
                return value is CARHeader
            case .array:
                return value is [String: Any]
            case .unknown:
                return true
        }
    }
}


