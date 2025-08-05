//
//  ContentDecoder.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-07-14.
//

import Foundation

/// A protocol representing a content decoding stream.
///
/// This allows pluggable decompression handlers (e.g. Gzip, Brotli, etc).
public protocol ContentDecoderProtocol: Sendable {

    /// The name of the header.
    var encodingName: String { get }

    /// Decodes input data asynchronously.
    ///
    /// - Parameter data: The data to decode.
    /// - Returns: The now-decoded `Data` object.
    func decode(_ data: Data) async throws -> Data
}

/// An enumeration which represents all decompression algorithms that the stream can use to decode
/// the data.
public enum ContentDecoders {

    /// An array of content decoders.
    ///
    /// This is meant to be fixed. Do not change the list of decoders unless the `common` TypeScript
    /// package in the `atproto` repository makes a change.
    private static let decoders: [String: ContentDecoderProtocol] = {
        let all: [ContentDecoderProtocol] = [
//            GzipDecoder(),
//            BrotliDecoder(),
//            DeflateDecoder(),
        ]
        return Dictionary(uniqueKeysWithValues: all.map { ($0.encodingName.lowercased(), $0) })
    }()

    /// Normalizes encoding string.
    ///
    /// - Parameter encoding: The string to decode.
    /// - Returns: An object conforming to ``ContentDecoderProtocol`` if the normaliz
    public static func decode(for encoding: String) -> ContentDecoderProtocol? {
        decoders[encoding.lowercased()]
    }

    /// Compiles all of the keys from ``decoders`` into one array.
    ///
    /// - Returns: An array of all of the keys from ``decoders`` as `String` objects.
    public static var allEncodingNames: [String] {
        Array(decoders.keys)
    }
}

// MARK: Compression Algorithms -
// gzip/x-gzip
//public struct GzipDecoder: ContentDecoderProtocol {
//    public var encodingName: String { "gzip" }
//
//    public func decode(_ data: Data) async throws -> Data {
//        var newData = data
//        newData.append("|GZ".data(using: .utf8)!)
//        return newData
//    }
//}

// deflate
//public struct DeflateDecoder: ContentDecoderProtocol {
//    public var encodingName: String { "deflate" }
//
//    public func decode(_ data: Data) async throws -> Data {
//        var newData = data
//        newData.append("|DF".data(using: .utf8)!)
//        return newData
//    }
//}

// br (Brotli)
//public struct BrotliDecoder: ContentDecoderProtocol {
//    public var encodingName: String { "br" }
//
//    public func decode(_ data: Data) async throws -> Data {
//        var newData = data
//        newData.append("|BR".data(using: .utf8)!)
//        return newData
//    }
//}
