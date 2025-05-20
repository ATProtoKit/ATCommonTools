//
//  DIDDocument.swift
//  ATCommonTools
//
//  Created by Christopher Jr Riley on 2025-05-10.
//

import Foundation

/// A representation of a verification method used in a DID document.
public struct VerificationMethod: Codable {

    /// The unique identifier of the verification method.
    public let id: String

    /// The type of cryptographic material used in the verification method.
    public let type: String

    /// The controller of the verification method.
    public let controller: String

    /// A multibase-encoded public key string.
    public let multibasePublicKey: String

    public init(id: String, type: String, controller: String, multibasePublicKey: String) {
        self.id = id
        self.type = type
        self.controller = controller
        self.multibasePublicKey = multibasePublicKey
    }

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case controller
        case multibasePublicKey = "publicKeyMultibase"
    }
}

/// A representation of a service entry in a DID document.
public struct Service: Codable {

    /// The unique identifier of the service.
    public let id: String

    /// The type of service being described.
    public let type: String

    /// The URL or endpoint associated with the service.
    public let serviceEndpoint: String

    public init(id: String, type: String, serviceEndpoint: String) {
        self.id = id
        self.type = type
        self.serviceEndpoint = serviceEndpoint
    }
}

/// A DID document containing identity-related information.
public struct DIDDocument: Codable {

    /// The unique decentralized identifier (DID) string that identifies this document.
    public let id: String

    /// An array of alternative identifiers associated with the decentralized identifier (DID). Optional.
    public let alsoKnownAs: [String]?

    /// An array of verification methods available for this decentralized identifier (DID). Optional.
    public let verificationMethod: [VerificationMethod]?

    /// An array of services linked to this decentralized identifier (DID). Optional.
    public let service: [Service]?

    public init(id: String, alsoKnownAs: [String]?, verificationMethod: [VerificationMethod]?, service: [Service]?) {
        self.id = id
        self.alsoKnownAs = alsoKnownAs
        self.verificationMethod = verificationMethod
        self.service = service
    }

    /// Determines whether the DID Document-related JSON is a valid DID Document.
    ///
    /// - Parameter didDocumentJSON: The JSON containing the DID Document.
    /// - Returns: `true` if it's valid, or `false` if not.
    public static func isDIDDocumentValid(_ didDocumentJSON: String) -> Bool {
        return true
    }

    /// Attempts to get the handle of the user account.
    ///
    /// - Returns: The handle of the user account, or `nil` (if it can't find it).
    public func getHandle() -> String? {
        // This searches the array. If there's nothing in the array, it returns `nil`.
        // If there is an item in the array, it will stop looping when it finds
        // the entry that contains "at://" and returns it (without the "at://").
        // If it finds no entries with it, it will return `nil`.
        return self.alsoKnownAs?
            .first(where: {
                $0.hasPrefix("at://")
            }).map {
                String($0.dropFirst(5))
            }
    }

    /// Attempts to get the signing key from the DID document.
    ///
    /// - Returns: A tuple, which contains the verification type and the multibase public key, or `nil` (if
    /// it failed to find one).
    public func getSigningKey() -> (type: String, multibasePublicKey: String)? {
        return self.getVerificationInformation(keyID: "atproto")
    }

    /// Attempts to go through the `VerificationMethod` array in order to find a specific entry.
    ///
    /// - Parameter keyID: The ID of the vertification method.
    /// - Returns: A tuple, which contains the verification type and the multibase public key, or `nil` (if
    /// it failed to find one).
    public func getVerificationInformation(keyID: String) -> (type: String, multibasePublicKey: String)? {
        let key = self.verificationMethod?.first { $0.id == "#\(keyID)" }

        guard let key = key else {
            return nil
        }

        return (
            type: key.type,
            multibasePublicKey: key.multibasePublicKey
        )
    }

    /// Attempts to get the `did:key` signing key.
    ///
    /// - Returns: The `did:key` signing key, or `nil` (if it can't find it).
    public func getSigningDIDKey() -> String? {
        let parsed = self.getSigningKey()

        guard let parsed = parsed else {
            return nil
        }

        return "did:key:\(parsed.multibasePublicKey)"
    }

    /// Attempts to get the endpoint of the Personal Data Server (PDS).
    ///
    /// - Returns: The URL endpoint of the Personal Data Server (PDS), or `nil` (if it can't find one).
    public func getPDSEndpoint() -> URL? {
        return self.getServiceEndpoint(options: (id: "#atproto_pds", type: "AtprotoPersonalDataServer"))
    }

    /// Attempts to get the endpoint of the feed generator.
    ///
    /// - Returns: The URL endpoint of the feed generator, or `nil` (if it can't find one).
    public func getFeedGenerator() -> URL? {
        return self.getServiceEndpoint(options: (id: "#bsky_fg", type: "BskyFeedGenerator"))
    }

    /// Attempts to get the endpoint of the Personal Data Server (PDS).
    ///
    /// - Returns: The URL endpoint of the notification service, or `nil` (if it can't find one).
    public func getNotificationEndpoint() -> URL? {
        return self.getServiceEndpoint(options: (id: "#bsky_notif", type: "BskyNotificationService"))
    }

    /// Attempts to get the service endpoint for the DID document.
    ///
    /// - Parameters:
    ///   - options: A tuple, containing the `id` and `type`. Both arguments are of type `String`.
    ///   `type` is optional.
    ///   - Returns: The URL of the service endpoint, or `nil` (if it can't find it).
    public func getServiceEndpoint(options: (id: String, type: String?)) -> URL? {
        let service = self.service?.first { $0.id == options.id }

        guard let service = service else {
            return nil
        }

        guard options.type != nil, service.type == options.type else {
            return nil
        }

        return validateURL(service.serviceEndpoint)
    }

    /// Validates the URL.
    ///
    /// - Parameter urlString: The URL as a string.
    /// - Returns: The URL, or `nil` (if it's invalid).
    public func validateURL(_ urlString: String) -> URL? {
        // Must be "http://" or "https://".
        guard urlString.starts(with: "http://") || urlString.starts(with: "https://") else {
            return nil
        }

        guard let url = URL(string: urlString) else {
            return nil
        }

        // Optionally, add SSRF protection (e.g., reject localhost/private IPs).
        if let host = url.host,
           host == "localhost" || host == "127.0.0.1" || host.hasPrefix("192.168.") {
            return nil
        }

        return url
    }

}

