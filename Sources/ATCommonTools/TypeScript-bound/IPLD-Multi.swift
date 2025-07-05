//
//  IPLD-Multi.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-06-25.
//

import Foundation
import MultiformatsKit
import SwiftCbor

extension CID: @retroactive CborCodable {

    /// The tagged value of the CID.
    public var tag: UInt64 { 42 }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let bytes = try container.decode(Data.self)

        self = try CID(rawData: bytes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawData)
    }
}
