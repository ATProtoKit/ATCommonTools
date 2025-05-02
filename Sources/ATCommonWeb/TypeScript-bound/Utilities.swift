//
//  Utilities.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-03-18.
//

import Foundation

/// Returns a shallow copy of an object without the specified keys.
///
/// If nothing is inputted into the `object` argument, then the function will return `nil`.
///
/// - Parameters:
///   - object: The object itself. Optional. Defaults to `nil`.
///   - rejectedKeys: An array of keys to remove.
/// - Returns: A `Dictionary`, where the key is of type `String` and the value is of type `T`.
public func omit<T>(object: [String: Any]? = nil, rejectedKeys: [String]) -> [String: T]? {
    guard let object = object else { return nil }

    var result = object
    for key in rejectedKeys {
        result.removeValue(forKey: key)
    }

    return result as? [String : T]
}

/// Returns a random number for the purposes of setting a variation of time for a request
/// or response.
///
/// The number will be between the negative value and positive value.
///
/// - Parameter maximumMilliseconds: The number of milliseconds.
/// - Returns: An `Int` value between `-[maximumMilliseconds]` and `+[maximumMilliseconds]`
public func jitter(maximumMilliseconds: Int) -> Int {
    return Int.random(in: -maximumMilliseconds...maximumMilliseconds)
}

/// Flattens an array of `[UInt8]` into one, big `[UInt8]`.
///
/// - Parameter arrays: The array of `[UInt8]`.
/// - Returns: The flattened `[UInt8]`.
public func flattenUInt8Arrays(_ arrays: [[UInt8]]) -> [UInt8] {
    return Array(arrays.joined())
}

/// Converts a stream of data into a buffer.
///
/// - Parameter stream: The stream of data.
/// - Returns: The resulting data.
public func streamToBuffer(stream: AsyncStream<Data>) async -> Data {
    var arrays: [[UInt8]] = []

    for await chunk in stream {
        let byteArray = Array(chunk)
        arrays.append(byteArray)
    }

    return Data(flattenUInt8Arrays(arrays))
}

extension Int {

    /// The Base32 string representation of the integer.
    public var base32String: String {
        let base32Alphabet = Array("234567abcdefghijklmnopqrstuvwxyz")

        guard self > 0 else { return "0" }

        var number = self
        var encoded = String()
        encoded.reserveCapacity(10)

        while number > 0 {
            let index = number % 32
            number /= 32

            encoded.insert(base32Alphabet[index], at: encoded.startIndex)
        }

        return encoded
    }
}

extension String {

    /// The integer value decoded from the Base32 string.
    public var base32DecodedValue: Int {
        var map = [Character: Int]()
        let chars = "234567abcdefghijklmnopqrstuvwxyz"

        // Populate the dictionary with character-to-index mappings.
        for (i, char) in chars.enumerated() {
            map[char] = i
        }

        return self.reduce(into: 0) { result, char in
            // Check if the character is valid in the Base-32 encoding.
            guard let value = map[char] else { return }

            // Accumulate the decoded integer.
            result = result * 32 + value
        }
    }
}

/// Splits an array into chunks of a specified size.
///
/// If the `chunkSize` argument is `0` or a negative number, then the function will return an
/// empty array.
///
/// - Parameters:
///   - array: The input array to be chunked.
///   - chunkSize: The maximum size of each chunk.
/// - Returns: A 2D array where each subarray contains at most `chunkSize` elements.
public func chunkArray<T>(_ array: [T], chunkSize: Int) -> [[T]] {
    guard chunkSize > 0 else { return [] }

    return stride(from: 0, to: array.count, by: chunkSize).map { startIndex in
        let endIndex = min(startIndex + chunkSize, array.count)
        return Array(array[startIndex..<endIndex])
    }
}

///
public func parseInt<T>(_ value: String?, with fallback: T) -> Any {
    guard let value = value else { return fallback }

    if let parsed = Int(value) {
        return parsed
    }

    return fallback
}

extension Int {

    /// Initializes an `Int` value, where the `String` value is converted into an `Int` value,
    /// with a fallback `Int` value if that fails.
    ///
    /// - Parameters:
    ///   - value: The `String` value to convert. Optional.
    ///   - fallback: An `Int` value to fallback to if the conversion fails.
    init(_ value: String?, fallback: Int) {
        self = Int(value ?? "") ?? fallback
    }
}
