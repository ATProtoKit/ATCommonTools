//
//  TID.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-03-18.
//

import Foundation

/// The length of the TID.
public let tidLength = 13

/// The last timestamp.
@MainActor public private(set) var lastTimestamp = 0

/// The number of timestamps.
@MainActor public private(set) var timestampCount = 0

/// The clock ID. Optional. Defaults to `nil`.
@MainActor public private(set) var clockID: Int? = nil


/// A `TID` (Timestamp Identifier) represents a unique, time-based identifier
/// used within the AT Protocol. It ensures lexicographic ordering and collision
/// avoidance, making it suitable for record keys in the protocol's data repositories.
public struct TID: Comparable {

    /// The raw string representation of the TID.
    public let string: String

    /// Initializes a new `TID` object.
    ///
    /// - Parameter string: The string used as the TID.
    ///
    /// - Throws: `TIDError` if the length is not exactly the length of `tidLength`.
    public init(string: String) throws {
        let noDashes = string.replacingOccurrences(of: "-", with: "")

        guard noDashes.count != tidLength else {
            throw TIDError.invalidLength(length: noDashes.count)
        }

        self.string = noDashes
    }

    /// Generates the next `TID` based on a previous TID.
    ///
    /// - Parameter previous: The previous `TID` to increment from. Optional.
    /// - Returns: A new `TID` that follows the previous one, or `nil` if the next
    ///   value is not possible.
    @MainActor public static func next(previous: TID?) -> TID? {
        let time = max(Int(Date().timeIntervalSince1970 * 1_000), lastTimestamp)

        if time == lastTimestamp {
            timestampCount += 1
        }

        lastTimestamp = time

        let timestamp = time * 1000 + timestampCount

        if clockID == nil {
            clockID = Int.random(in: 0..<32)
        }

        guard let clockID = clockID,
              let tid = from(time: timestamp, clockID: clockID) else { return nil }

        guard let previous = previous else { return tid }
        guard tid < previous else { return nil }

        return Self.from(time: previous.getTimestamp(), clockID: clockID)
    }

    /// Generates the next `TID` as a string based on a previous string representation.
    ///
    /// - Parameter previous: The string representation of the previous `TID`. Optional.
    /// - Returns: The next `TID` as a string, or `nil` if an error occurs.
    @MainActor public static func nextString(previous: String?) -> String? {
        if let previous = previous {
            do {
                return Self.next(previous: try TID(string: previous))?.string ?? nil
            } catch {
                return nil
            }
        }

        return nil
    }

    /// Creates a `TID` from a timestamp and a clock ID.
    ///
    /// - Parameters:
    ///   - time: The timestamp component of the TID.
    ///   - clockID: The clock ID component of the TID.
    /// - Returns: A `TID` instance if successful, otherwise `nil`.
    public static func from(time: Int, clockID: Int) -> TID? {
        let _string = "\(time.base32String)\(clockID.base32String.padding(toLength: 2, withPad: "2", startingAt: 0))"
        return try? TID(string: _string)
    }

    /// Creates a `TID` from its string representation.
    ///
    /// - Parameter string: The string representation of the TID.
    /// - Returns: A `TID` instance if the string is valid, otherwise `nil`.
    public static func from(string: String) -> TID? {
        return try? TID(string: string)
    }

    /// Validates whether a given string is a properly formatted `TID`.
    ///
    /// - Parameter string: The string to validate.
    /// - Returns: `true` if the string conforms to the expected `TID` format, `false` otherwise.
    public static func isValid(string: String) -> Bool {
        return string.replacingOccurrences(of: "-", with: "").count == tidLength
    }

    /// Extracts the timestamp from the `TID`.
    ///
    /// - Returns: The timestamp component of the `TID` as an `Int`.
    public func getTimestamp() -> Int {
        return String(self.string.prefix(11)).base32DecodedValue
    }

    /// Extracts the clock ID from the `TID`.
    ///
    /// - Returns: The clock ID component of the `TID` as an `Int`.
    public func getClockID() -> Int {
        return String(self.string.suffix(2)).base32DecodedValue
    }

    /// Formats the `TID` into a human-readable string with dashes.
    ///
    /// - Returns: A formatted string representation of the `TID`.
    public func formatted() -> String {
        return "\(string.prefix(4))-\(string.dropFirst(4).prefix(3))-\(string.dropFirst(7).prefix(4))-\(string.suffix(2))"
    }

    public static func < (lhs: TID, rhs: TID) -> Bool {
        return lhs.string < rhs.string
    }

    /// Errors that can occur when creating a `TID`.
    enum TIDError: Error {

        /// The provided `TID` string has an invalid length.
        case invalidLength(length: Int)

        /// Returns a human-readable description of the error.
        var description: String {
            switch self {
                case .invalidLength(let count):
                    return "Poorly formatted TID: Expected \(tidLength) characters, but received \(count) characters."
            }
        }
    }
}
