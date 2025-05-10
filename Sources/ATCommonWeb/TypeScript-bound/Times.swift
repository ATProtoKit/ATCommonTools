//
//  Times.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-05-10.
//

import Foundation

/// An enum for time-related constants and utilities.
public enum TimeUtilities {

    /// One second, in milliseconds.
    public static let second: TimeInterval = 1_000

    /// One minute, in milliseconds.
    public static let minute: TimeInterval = second * 60

    /// One hour, in milliseconds.
    public static let hour: TimeInterval = minute * 60

    /// One day, in milliseconds.
    public static let day: TimeInterval = hour * 24

    /// Checks if a given time is less than a certain range ago.
    ///
    /// - Parameters:
    ///   - range: The number of milliseconds to check against.
    ///   - time: The starting date.
    /// - Returns: `true` if the current time is within the range, or `false` if it isn't.
    public func isWithinMilliseconds(_ range: TimeInterval, from time: Date) -> Bool {
        let nowInMilliseconds = Date().timeIntervalSince1970 * 1_000
        let timeInMilliseconds = time.timeIntervalSince1970 * 1_000

        return nowInMilliseconds < timeInMilliseconds + range
    }

    /// Adds a specified number of hours to a given date.
    ///
    /// If `startingDate` is `nil`, the current date and time is used.
    ///
    /// - Parameters:
    ///   - hours: The number of hours to add.
    ///   - startingDate: The date to start from. Optional. Defaults to `nil`
    /// - Returns: A new instance of `Date`, with the hours added, or `nil` if the operation fails.
    public func add(hours: Int, to startingDate: Date? = nil) -> Date? {
        let currentDate = startingDate ?? Date()
        var calendar = Calendar(identifier: .gregorian)

        if let utcTimeZone = TimeZone(secondsFromGMT: 0) {
            calendar.timeZone = utcTimeZone
        }

        return calendar.date(byAdding: .hour, value: hours, to: currentDate)
    }
}
