//
//  Async.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-03-18.
//

import Foundation

/// Reads values from an `AsyncSequence` until a condition is met or an external signal resolves.
///
/// - Parameters:
///   - sequence: The `AsyncSequence` to read from.
///   - isDone: Asynchronously evaluates whether reading should stop.
///   - waitFor: A `Task<Void, Never>` that triggers an external stop signal when completed.
///   Optional. Defaults to `nil`.
///   - maxLength: The maximum number of elements to collect before stopping. Defaults to `.max`.
///
/// - Returns: An array containing the collected elements from the sequence.
func readFromAsyncSequence<S: AsyncSequence>(
    _ sequence: S,
    isDone: @escaping (S.Element?) async -> Bool,
    waitFor: Task<Void, Never>? = nil,
    maxLength: Int = .max
) async -> [S.Element] {
    var results: [S.Element] = []
    var iterator = sequence.makeAsyncIterator()
    var lastValue: S.Element?

    // Define an early stop mechanism
    func shouldStop() async -> Bool {
        return await isDone(lastValue) || results.count >= maxLength
    }

    // Handle external stop signal (if provided)
    var hasStoppedExternally = false
    let externalStopTask = Task {
        await waitFor?.value
        hasStoppedExternally = true
    }

    defer { externalStopTask.cancel() }  // Cleanup on exit

    // Read from sequence
    while !hasStoppedExternally, let value = try? await iterator.next() {
        lastValue = value
        results.append(value)

        if await shouldStop() {
            break
        }
    }

    return results
}

/// A structure that defines a deferrable, asynchronous event stream.
///
/// This allows you to manually trigger an event that can be awaited in an `AsyncStream`.
struct DeferrableStream {

    /// An asynchronous stream of void events.
    public let stream: AsyncStream<Void>

    /// The continuation that allows externally sending values to the stream.
    private let continuation: AsyncStream<Void>.Continuation

    /// Initializes a new `DeferrableStream` instance.
    public init() {
        var cont: AsyncStream<Void>.Continuation!
        self.stream = AsyncStream { continuation in
            cont = continuation
        }

        self.continuation = cont
    }

    /// Resolves the deferrable by yielding a signal to the stream.
    public func resolve() {
        continuation.yield(())
    }
}

/// An asynchronous buffer that stores elements and allows streaming them asynchronously.
/// This actor ensures thread-safe operations and can be used to buffer elements
/// before processing them via an `AsyncStream`.
actor AsyncBuffer<T: Sendable> {

    /// Returns the current size of the buffer.
    public var size: Int {
        buffer.count
    }

    /// Indicates whether the buffer has been closed.
    public var isBufferClosed: Bool {
        isClosed
    }

    /// The internal storage for buffered elements.
    private var buffer: [T] = []

    /// The continuation for yielding elements to the `AsyncStream`. Optional.
    private var continuation: AsyncStream<T>.Continuation?

    /// Indicating whether the buffer has been closed. Defaults to `false`.
    private var isClosed = false

    /// An error to be thrown when the buffer is closed. Optional.
    private var toThrow: Error?

    /// The maximum size of the buffer. Optional.
    private let maxSize: Int?

    /// Initializes the `AsyncBuffer`.
    ///
    /// - Parameter maxSize: The maximum number of elements that can be stored in the buffer.
    /// Optional. Defaults to `nil`.
    public init(maxSize: Int? = nil) {
        self.maxSize = maxSize
    }

    /// Pushes a single item into the buffer.
    ///
    /// If the buffer is closed, the operation will have no effect.
    ///
    /// - Parameter item: The item to be added to the buffer.
    public func push(_ item: T) {
        guard !isClosed else { return }
        buffer.append(item)
        yieldItem(item)
    }

    /// Pushes multiple items into the buffer.
    ///
    /// If the buffer is closed, the operation will have no effect.
    ///
    /// - Parameter items: An array of items to be added to the buffer.
    public func pushMany(_ items: [T]) {
        guard !isClosed else { return }
        buffer.append(contentsOf: items)
        for item in items {
            yieldItem(item)
        }
    }

    /// Closes the buffer, preventing further additions and ending the stream.
    public func close() {
        isClosed = true
        continuation?.finish()
    }

    /// Closes the buffer and throws an error.
    ///
    /// - Parameter error: The error to be associated with the buffer closure.
    public func throwError(_ error: Error) {
        toThrow = error
        isClosed = true
        continuation?.finish()
    }

    /// Returns an `AsyncStream` for consuming buffered elements asynchronously.
    ///
    /// - Returns: An `AsyncStream<T>` that provides elements from the buffer.
    public func stream() -> AsyncStream<T> {
        return AsyncStream { continuation in
            self.continuation = continuation
            Task { await self.drainBuffer() }
        }
    }

    /// Drains the buffer by yielding all remaining elements to the stream.
    private func drainBuffer() async {
        while !buffer.isEmpty {
            let item = buffer.removeFirst()
            yieldItem(item)
        }

        if toThrow != nil || isClosed {
            continuation?.finish()
        }
    }

    /// Yields an item to the `AsyncStream`.
    ///
    /// - Parameter item: The item to yield.
    private func yieldItem(_ item: T) {
        continuation?.yield(item)
    }
}
