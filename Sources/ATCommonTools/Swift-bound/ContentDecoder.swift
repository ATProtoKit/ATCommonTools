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
public protocol ContentDecoder: Sendable {

    ///
    var encodingName: String { get }

    /// Decode input data asynchronously.
    func decode(_ data: Data) async throws -> Data
}

///
public actor ContentDecoderRegistry {

    ///
    private var decoders: [String: ContentDecoder] = [:]

    ///
    public init() {}

    ///
    public func register(_ decoder: ContentDecoder) {
        decoders[decoder.encodingName.lowercased()] = decoder
    }

    ///
    public func decoder(for name: String) -> ContentDecoder? {
        decoders[name.lowercased()]
    }

    ///
    public func allDecoders() -> [ContentDecoder] {
        Array(decoders.values)
    }
}

// MARK: Compression Algorithms -
// gzip/x-gzip
//struct GzipDecoder: ContentDecoder {
//    var encodingName: String { "gzip" }
//
//    func decode(_ data: Data) async throws -> Data {
//        return try  /*name of decoder*/.decompress(data)
//    }
//}

// deflate
//struct DeflateDecoder: ContentDecoder {
//    var encodingName: String { "gzip" }
//
//    func decode(_ data: Data) async throws -> Data {
//        return try /*name of decoder*/.decompress(data)
//    }
//}

// br (Brotli)
//struct BrotliDecoder: ContentDecoder {
//    var encodingName: String { "gzip" }
//
//    func decode(_ data: Data) async throws -> Data {
//        return try /*name of decoder*/.decompress(data)
//    }
//}
