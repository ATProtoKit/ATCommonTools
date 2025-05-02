//
//  Retry.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-03-29.
//

import Foundation

/// Configuration options for retrying a failing operation.
public struct RetryOptions {

    /// The maximum number of retries.
    public var maxRetries: Int

    /// The number of milliseconds to wait until the operation can be retried. Optional.
    ///
    /// Contains a required `Int` closure, which represents the attempt number.
    ///
    /// If `nil` is returned, then the operation is considered cancelled.
    public var getWaitTime: (Int) -> TimeInterval?

    /// Creates an instance of `RetryOptions`.
    ///
    /// - Parameters:
    ///   - maxRetries: The maximum number of retry attempts. Default is `3`.
    ///   - getWaitTime: A closure that returns the delay before the next retry. Optional.
    ///   Defaults to ` exponentialBackoff($0)`, where `$0` represents the attempt number.
    public init(maxRetries: Int = 3, getWaitTime: @escaping (Int) -> TimeInterval? = { exponentialBackoff($0) }) {
        self.maxRetries = maxRetries
        self.getWaitTime = getWaitTime
    }
}

/// A protocol that defines logic for determining whether a failed operation should be retried.
public protocol Retryable {

    /// Determines whether the operation should be retried, depending on the error.
    ///
    /// - Parameter error: The error that caused the operation to fail.
    /// - Returns: `true` if the operation should be retried, or `false` if it shouldn't.
    func shouldRetry(for error: Error) -> Bool
}

/// A concrete implementation of `Retryable` that always retries regardless of the error.
public struct AlwaysRetry: Retryable {

    /// Creates an empty instance of `AlwaysRetry`.
    public init() {}

    public func shouldRetry(for error: Error) -> Bool {
        return true
    }
}

/// A concrete implementation of `Retryable` that always retries regardless of the error.
///
/// - Parameters:
///   - options: Configuration for retry behavior. Defaults to `RetryOptions()`.
///   - retryable: An instance of a `Retryable` object. Defaults to an instance of `AlwaysRetry`.
///   - operation: An asynchronous operation to be performed.
/// - Returns: The result of the successful operation.
///
///   - Throws: The last error encountered if all retry attempts fail.
public func retry<T>(
    options: RetryOptions = RetryOptions(),
    retryable: Retryable = AlwaysRetry(),
    operation: @escaping () async throws -> T
) async throws -> T {
    var retries = 0
    var lastError: Error?

    while true {
        do {
            return try await operation()
        } catch {
            let waitTime = options.getWaitTime(retries)
            let willRetry = retries < options.maxRetries &&
            waitTime != nil &&
            retryable.shouldRetry(for: error)

            if willRetry {
                retries += 1
                if let delay = waitTime, delay > 0 {
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
            } else {
                lastError = error
                break
            }
        }
    }

    throw lastError ?? RetryError.unknown
}

/// Creates and executes a retryable asynchronous operation.
///
/// - Parameters:
///   - retryable: An instance of `Retryable` that determines retry behavior.
///   - options: Retry configuration. Defaults to `RetryOptions()`.
///   - operation: The asynchronous operation to be retried.
/// - Returns: The result of the successful operation.
///
/// - Throws: The last error encountered if all retry attempts fail.
public func createRetryable<T>(retryable: Retryable, options: RetryOptions = RetryOptions(), operation: @escaping () async throws -> T) async throws -> T {
    return try await retry(options: options, retryable: retryable, operation: operation)
}

/// Calculates an exponential backoff delay with jitter for the given attempt.
///
/// - Parameters:
///   - attempt: The attempt number.
///   - multiplier: The base multiplier for exponential growth. Defaults to `0.1`.
///   - maxDelay: The maximum amount of time to wait before retrying the operation
///   (in seconds). Defaults to `1.0`.
/// - Returns: A time interval representing the delay before the next retry.
public func exponentialBackoff(_ attempt: Int, multiplier: Double = 0.1, maxDelay: Double = 1.0) -> TimeInterval {
    let exponent = pow(2.0, Double(attempt))
    let rawDelay = exponent * multiplier
    let delay = min(rawDelay, maxDelay)
    return jitter(delay)
}

/// Applies a random amount of jitter to a given delay.
///
/// - Parameter value: The original delay time (in seconds).
/// - Returns: A new delay value with random jitter applied.
public func jitter(_ value: TimeInterval) -> TimeInterval {
    let delta = value * 0.15
    return value + Double.random(in: -delta...delta)
}

/// Errors related to retrying operations.
public enum RetryError: Error {

    /// An unknown retry error occurred.
    case unknown

    public var description: String? {
        switch self {
            case .unknown:
                return "Retry failed but no error was captured. This should not happen."
        }
    }
}
