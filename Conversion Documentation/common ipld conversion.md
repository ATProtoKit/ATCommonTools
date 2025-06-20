# Conversion for `common/ipld.ts`

## `export const cborEncode = cborCodec.encode`

This is redundant and will not be converted. Calling the equivalent method directly is good enough.

## `export const cborDecode = cborCodec.decode`

This is redundant and will not be converted. Calling the equivalent method directly is good enough.

## `export const dataToCborBlock = async (data: unknown)`

This has been converted.

## `export const cidForCbor = async (data: unknown): Promise<CID>`

This is redundant and will not be converted. Simply getting the `cid` property of `makeCBORBlock(from:)` is enough.

## `export const isValidCid = async (cidStr: string): Promise<boolean>`

This has been converted.

## `export const cborBytesToRecord = (bytes: Uint8Array,): Record<string, unknown>`

This has been converted. However, nothing is using this method, so it will be commented out until further notice.

## `export const verifyCidForBytes = async (cid: CID, bytes: Uint8Array)`

This has been converted.

## `export const sha256ToCid = (hash: Uint8Array, codec: number): CID`

This is redundant and will not be converted. Use the following instead:

```swift
let data = // data object...
try await MultihashFactory.shared.register(SHA256Multihash())
let hash = try await MultihashFactory.shared.hash(using: "sha2-256", data: data)

let cid = try await CID(version: .v1, data: hash.digest)
```

## `export const sha256RawToCid = (hash: Uint8Array): CID`

This is redundant and will not be converted. Use `CID(version: CIDVersion = .v1, data: Data) async throws` instead.

## `export const parseCidFromBytes = (cidBytes: Uint8Array): CID`

This has been converted.

## `export class VerifyCidTransform extends Transform`

This has been converted, but as a method instead of a class.

## `const asError = (err: unknown): Error`

This is unneeded and will not be converted.

## `export class VerifyCidError extends Error`

This is unneeded and will not be converted.
