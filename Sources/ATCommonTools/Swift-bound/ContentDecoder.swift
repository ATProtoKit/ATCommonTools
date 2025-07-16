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

    ///
    var encodingName: String { get }

    /// Decode input data asynchronously.
    func decode(_ data: Data) async throws -> Data
}

///
public enum ContentDecoders {

    /// An array of content decoders.
    private static let decoders: [String: ContentDecoderProtocol] = {
        let all: [ContentDecoderProtocol] = [
//            GzipDecoder(),
//            BrotliDecoder(),
//            DeflateDecoder(),
        ]
        return Dictionary(uniqueKeysWithValues: all.map { ($0.encodingName.lowercased(), $0) })
    }()

    ///
    public static func decoder(for encoding: String) -> ContentDecoderProtocol? {
        decoders[encoding.lowercased()]
    }

    /// 
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
