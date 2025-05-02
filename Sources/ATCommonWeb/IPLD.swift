//
//  IPLD.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-03-18.
//

import Foundation
import MultiformatsKit


public struct IPLD {

    /// A type-safe and thread-safe representation of JSON-compatible values, used for encoding and
    /// decoding arbitrary JSON data.
    public enum JSONValue: Codable, Equatable, Hashable {

        /// A `String` object.
        case string(String)

        /// A `Double` object.
        case number(Double)

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
            } else if let number = try? container.decode(Double.self) {
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
                case .array(let values):
                    try container.encode(values)
                case .dictionary(let dictionary):
                    try container.encode(dictionary)
            }
        }
    }


    // TODO: Fix this to remove the errors.
//    public enum IPLDValue: Codable, Equatable, Hashable {
//
//        /// A `String` object.
//        case string(String)
//
//        /// A `Double` object.
//        case number(Double)
//
//        /// A `Bool` object.
//        case bool(Bool)
//
//        /// A `nil` object.
//        case `nil`
//
//        /// An `Array` of `IPLDValue` objects.
//        case array([IPLDValue])
//
//        /// A `Dictionary` object, with `IPLDValue` as the value.
//        case dictionary([String: IPLDValue])
//
//        /// A `CID` object.
//        //    case cid(CID)
//
//        /// A `Data` object.
//        case bytes(Data)
//
//        public init(from decoder: Decoder) throws {
//            let container = try decoder.singleValueContainer()
//
//            if container.decodeNil() {
//                self = .nil
//            } else if let bool = try? container.decode(Bool.self) {
//                self = .bool(bool)
//            } else if let number = try? container.decode(Double.self) {
//                self = .number(number)
//            } else if let string = try? container.decode(String.self) {
//                self = .string(string)
//            } else if let array = try? container.decode([IPLDValue].self) {
//                self = .array(array)
//            } else if let object = try? container.decode([String: IPLDValue].self) {
//                self = .dictionary(object)
//                //        } else if let cid = try? container.decode(CID.self) {
//                //            self = .cid(cid)
//            } else if let data = try? container.decode(Data.self) {
//                self = .bytes(data)
//            } else {
//                throw DecodingError.dataCorruptedError(
//                    in: container,
//                    debugDescription: "Unsupported IPLD value"
//                )
//            }
//        }
//
//        public func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//
//            switch self {
//                case .string(let value):
//                    try container.encode(value)
//                case .number(let value):
//                    try container.encode(value)
//                case .bool(let value):
//                    try container.encode(value)
//                case .nil:
//                    try container.encodeNil()
//                case .array(let values):
//                    try container.encode(values)
//                case .dictionary(let dictionary):
//                    try container.encode(dictionary)
//                    //            case .cid(let cid):
//                    //                try container.encode(cid)
//                case .bytes(let data):
//                    try container.encode(data)
//            }
//        }
//    }
//
//    public static func jsonToIpld(_ value: JSONValue) -> IPLDValue {
//        switch value {
//            case .string(let str):
//                // Handle special IPLD markers
//                if let json = try? JSONSerialization.jsonObject(with: Data(str.utf8)) as? [String: Any],
//                   let onlyKey = json.keys.first, json.count == 1 {
//                    if onlyKey == "$link", let linkStr = json["$link"] as? String, let cid = try? CID(string: linkStr) {
//                        return .cid(cid)
//                    }
//                    if onlyKey == "$bytes", let base64Str = json["$bytes"] as? String, let data = Data(base64Encoded: base64Str) {
//                        return .bytes(data)
//                    }
//                }
//                return .string(str)
//            case .number(let num):
//                return .number(num)
//            case .bool(let bool):
//                return .bool(bool)
//            case .nil:
//                return .nil
//            case .array(let arr):
//                return .array(arr.map { jsonToIpld($0) })
//            case .dictionary(let dict):
//                var newDict: [String: IPLDValue] = [:]
//                for (key, val) in dict {
//                    newDict[key] = jsonToIpld(val)
//                }
//                return .dictionary(newDict)
//        }
//    }
//
//    public static func ipldToJson(_ value: IPLDValue) -> JSONValue {
//        switch value {
//            case .string(let str):
//                return .string(str)
//            case .number(let num):
//                return .number(num)
//            case .bool(let bool):
//                return .bool(bool)
//            case .nil:
//                return .nil
//            case .array(let arr):
//                return .array(arr.map { ipldToJson($0) })
//            case .dictionary(let dict):
//                var newDict: [String: JSONValue] = [:]
//                for (key, val) in dict {
//                    newDict[key] = ipldToJson(val)
//                }
//                return .dictionary(newDict)
//            case .cid(let cid):
//                return .dictionary(["$link": .string(cid.description)])
//            case .bytes(let data):
//                return .dictionary(["$bytes": .string(data.base64EncodedString())])
//        }
//    }

}
