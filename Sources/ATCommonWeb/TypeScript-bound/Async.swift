//
//  Async.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-03-18.
//

import Foundation

/// Errors that can occur with certain Ayncronous buffer tasks.
public enum AsyncBufferFullError: Error, LocalizedError, CustomStringConvertible {

    /// The buffer size has been reached.
    ///
    /// - Parameter maxSize: The maximum byte size that can be reached.
    case bufferSizeTooLarge(maxSize: Int)

    public var errorDescription: String? {
        switch self {
            case .bufferSizeTooLarge(let maxSize):
                return "Buffer size too large. Max size is \(maxSize) bytes."
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}
