//
//  DuplexStream.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-07-08.
//

import Foundation

/// A protocol describing the interface for a duplex stream endpoint.
///
/// Types conforming to this protocol allow writing data to the paired endpoint and reading data
/// sent from the paired endpoint asynchronously.
public protocol DuplexStream: Sendable {

    /// Writes data to the paired endpoint asynchronously.
    ///
    /// - Parameter data: The data to send to the other endpoint.
    func write(_ data: Data) async

    /// Registers a handler to receive the next chunk of data from the paired endpoint.
    ///
    /// If data is already available, the handler is called immediately. Otherwise, the handler is stored
    /// and called when new data arrives.
    ///
    /// - Parameter handler: A closure that is called with the next available data.
    func read(_ handler: @Sendable @escaping (Data) -> Void) async
}

/// An in-memory actor-based implementation of a duplex stream endpoint.
///
/// This is a very basic implementation of the `Duplex` module of "node:stream".
///
/// Each endpoint manages its own incoming buffer and pending read handlers. Data written from one
/// endpoint is delivered to its peer's `receive` method.
public actor DuplexStreamEndpoint: DuplexStream {

    /// A FIFO buffer storing incoming data that has not yet been read.
    private var buffer: [Data] = []

    /// A queue of handlers waiting for incoming data.
    ///
    /// Each handler is called with a single `Data` value and then removed from the queue.
    private var readHandlers: [(Data) -> Void] = []

    /// A weak reference to the paired endpoint. Optional.
    ///
    /// This ensures there is no strong reference cycle between endpoints.
    private weak var peer: DuplexStreamEndpoint?

    /// Sets the paired endpoint for this duplex stream endpoint.
    ///
    /// - Parameter other: The peer endpoint to pair with.
    public func setPeer(_ other: DuplexStreamEndpoint) {
        self.peer = other
    }

    /// Writes data to the paired endpoint.
    ///
    /// The data is sent to the peer's internal `receive` method asynchronously.
    ///
    /// - Parameter data: The data to send.
    public func write(_ data: Data) {
        // Deliver data to the peer's pending readers, or buffer
        Task {
            await peer?.receive(data)
        }
    }

    /// Internal method used by the peer endpoint to deliver data to this endpoint.
    ///
    /// - Parameter data: The data received from the peer.
    internal func receive(_ data: Data) {
        if !readHandlers.isEmpty {
            // There’s a reader waiting: deliver immediately
            let handler = readHandlers.removeFirst()
            handler(data)
        } else {
            // No reader yet: buffer data
            buffer.append(data)
        }
    }

    /// Registers a handler to receive the next available chunk of data.
    ///
    /// If data is already buffered, the handler is called immediately. Otherwise, the handler is queued and
    /// will be called when new data arrives.
    ///
    /// - Parameter handler: The closure to call with the received data.
    public func read(_ handler: @Sendable @escaping (Data) -> Void) {
        if !buffer.isEmpty {
            // Data available: deliver immediately
            let data = buffer.removeFirst()
            handler(data)
        } else {
            // No data yet: store handler
            readHandlers.append(handler)
        }
    }

    /// Asynchronously reads the next available chunk of data from the stream.
    ///
    /// This function suspends the caller until data becomes available from the paired endpoint. When data
    /// is available, it returns the data as a `Data` value.
    ///
    /// ### Usage Example
    /// ```swift
    /// // Assume `endpoint` is a DuplexStreamEndpoint.
    /// let data = await endpoint.read()
    /// print("Received: \(String(data: data, encoding: .utf8) ?? "<non-UTF8 data>")")
    /// ```
    ///
    /// - Important: This function will suspend until another endpoint writes data.
    ///
    /// - Returns: The next chunk of data received from the paired endpoint.
    public func read() async -> Data {
        await withCheckedContinuation { continuation in
            Task { [weak self] in
                await self?.read { data in
                    continuation.resume(returning: data)
                }
            }
        }
    }
}

/// Creates a pair of interconnected duplex stream endpoints.
///
/// After initialization, `endpointA` and `endpointB` can send data to and receive data from each other.
///
/// Example usage:
/// ```swift
/// let pair = await DuplexStreamPair()
/// let endpointA = pair.endpointA
/// let endpointB = pair.endpointB
/// ```
public final class DuplexStreamPair: Sendable {

    /// The first endpoint in the duplex stream pair.
    public let endpointA: DuplexStreamEndpoint

    /// The second endpoint in the duplex stream pair.
    public let endpointB: DuplexStreamEndpoint

    /// Initializes the duplex stream pair, connecting both endpoints.
    ///
    /// The endpoints are automatically paired together.
    public init() async {
        endpointA = DuplexStreamEndpoint()
        endpointB = DuplexStreamEndpoint()

        await endpointA.setPeer(endpointB)
        await endpointB.setPeer(endpointA)
    }
}
