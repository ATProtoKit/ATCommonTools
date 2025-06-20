//
//  IPLD.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-06-19.
//

import Foundation
import SwiftCbor
import MultiformatsKit
import ATCommonWeb
import Crypto

/// A namespace for IPLD-related methods.
public enum IPLD {

    /// Converts a `Data` object to a CBOR block.
    ///
    /// - Parameter value: The `Data` value to convert.
    /// - Returns: A tuple, which contains the original data value, the encoded CBOR block, and the CID of
    /// the hashed value.
    ///
    /// - Throws: An error if CBOR encoding fails, data hashing fails, or the method fails to create
    /// a `CID` object.
    public static func makeCBORBlock(from data: Data) async throws -> (hashedValue: Data, cborBytes: Data, cid: CID) {
        let cborEncoder = CborEncoder()

        let bytes = try cborEncoder.encode(data)

        try await MultihashFactory.shared.register(SHA256Multihash())
        let hash = try await MultihashFactory.shared.hash(using: "sha2-256", data: bytes)

        let cid = try await CID(version: .v1, data: hash.digest)

        return (hashedValue: data, cborBytes: bytes, cid: cid)
    }

    /// Determines whether the string representation of the CID is valid.
    ///
    /// - `true` if it's valid, or `false` if it isn't.
    public static func isCIDStringValid(cidString: String) async -> Bool {
        do {
            _ = try CID.decode(from: cidString)
            return true
        } catch {
            return false
        }
    }

//    /// Creates a dictionary from CBOR encoded data.
//    ///
//    /// - Parameter cborBytes: The CBOR encoded data to convert.
//    /// - Returns: A `[String: Data]` dictionary.
//    public static func makeDictionary(from cborBytes: Data) throws -> [String: Data] {
//        let cborDecoder = CborDecoder()
//
//        let data = try cborDecoder.decode([String: Data].self, from: cborBytes)
//        return data
//    }

    /// Verifies whether the given CID corresponds to the provided `Data` object.
    ///
    /// - Parameters:
    ///   - cid: The `CID` object to verify.
    ///   - data: The raw byte data to compare against the CID.
    ///
    /// - Throws: An error if the CID does not match the digest of the bytes.
    public static func verify(cid: CID, correspondsTo data: Data) async throws {
        try await MultihashFactory.shared.register(SHA256Multihash())
        let hash = try await MultihashFactory.shared.hash(using: "sha2-256", data: data)

        let expectedCID = try await CID(version: .v1, data: hash.digest)

        guard try cid.encode() == expectedCID.encode() else {
            throw CIDError.invalidCID(message: "The provided CID does not match the data. Expected: \(expectedCID), Actual: \(cid).")
        }
    }

    /// Parses the `CID` object from the `Data` object.
    ///
    /// - Parameter data: The `Data` object to convert.
    /// - Returns: A `CID` object from the `Data` object.
    ///
    /// - Throws: An error if the version number, codec, hash type, or hash length is unsupported.
    public static func parseCID(from data: Data) async throws -> CID {
        let uInt8array = [UInt8](data)

        let version = uInt8array[0]
        guard version == 0x01 else {
            throw CIDError.invalidCID(message: "CID version is not supported. Expected: '0x01', Actual: \(version).")
        }

        let codec = uInt8array[1]
        guard codec == 0x55 || codec == 0x71 else {
            throw CIDError.invalidCID(message: "Unsupported codec. Expected: '0x55' or '0x71', Actual: \(codec).")
        }

        let hashType = uInt8array[2]
        guard hashType == 0x12 else {
            throw CIDError.invalidCID(message: "Unsupported hash type. Expected: '0x12', Actual: \(hashType).")
        }

        let hashLength = uInt8array[3]
        guard hashLength == 32 else {
            throw CIDError.invalidCID(message: "Unsupported hash length. Expected: '32', Actual: \(hashLength).")
        }

        let remainingData = Data((uInt8array[4..<uInt8array.count]))

        return try await CID(version: .v1, data: remainingData)
    }

    /// Returns a validated stream of `Data` chunks, ensuring the final stream contents match the given CID.
    ///
    /// - Parameters:
    ///   - stream: The input `AsyncStream<Data>` representing a sequence of raw data chunks.
    ///   - expectedCID: The expected `CID` against which the final SHA-256 digest will be compared.
    ///
    /// - Returns: An `AsyncThrowingStream<Data, Error>` that yields the same chunks as the input stream.
    /// If the hash of the complete stream does not match `expectedCID`, the stream will terminate with
    /// a `CIDError.invalidCID`.
    public static func verifyCIDStream(
        for stream: AsyncStream<Data>,
        expectedCID: CID
    ) -> AsyncThrowingStream<Data, Error> {
        AsyncThrowingStream { continuation in
            Task {
                var hasher = SHA256()
                do {
                    for try await chunk in stream {
                        hasher.update(data: chunk)
                        continuation.yield(chunk)
                    }

                    let actualCID = try await CID(version: .v1, data: Data(hasher.finalize()))

                    if actualCID != expectedCID {
                        throw CIDError.invalidCID(message: "The provided CID does not match the data. Expected: \(expectedCID), Actual: \(actualCID).")
                    }

                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

}

/// A class that simulates a Transform stream which passes data through
/// and verifies the CID at the end.
public class VerifyCIDTransform {

    /// The SHA256 hash/
    private var hasher = SHA256()

    /// The expected `CID` object.
    private let expectedCid: CID

    /// Any data that's being collected.
    private var collectedData = Data()

    /// Initializes a `VerifyCIDTransform`.
    ///
    /// - Parameter cid: A `CID` object.
    public init(cid: CID) {
        self.expectedCid = cid
    }


}
