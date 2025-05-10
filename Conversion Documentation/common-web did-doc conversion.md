# Conversion for `common-web/did-doc.ts`

## `export const isValidDidDoc = (doc: unknown): doc is DidDocument =>`

This has been converted.

This function has been put into a `struct` named `DIDDocument`. It's now a `static` method.

## `export const getDid = (doc: DidDocument): string =>`

This has been converted.

This function has been put into a `struct` named `DIDDocument`. `doc` is now replaced with the properties of the `struct`.

## `export const getHandle = (doc: DidDocument): string | undefined`

This has been converted.

This function has been put into a `struct` named `DIDDocument`. `doc` is now replaced with the properties of the `struct`.

## `export const getSigningKey = (doc: DidDocument,): { type: string; publicKeyMultibase: string } | undefined`

This has been converted.

This function has been put into a `struct` named `DIDDocument`. `doc` is now replaced with the properties of the `struct`.

## `export const getVerificationMaterial = (doc: DidDocument, keyId: string,): { type: string; publicKeyMultibase: string } | undefined`

This has been converted.

This function has been put into a `struct` named `DIDDocument`. `doc` is now replaced with the properties of the `struct`.

## `export const getSigningDidKey = (doc: DidDocument): string | undefined`

This has been converted.

This function has been put into a `struct` named `DIDDocument`. `doc` is now replaced with the properties of the `struct`.

## `export const getPdsEndpoint = (doc: DidDocument): string | undefined`

This is been converted.

This function has been put into a `struct` named `DIDDocument`. `doc` is now replaced with the properties of the `struct`.

## `export const getFeedGenEndpoint = (doc: DidDocument): string | undefined`

This is been converted.

This function has been put into a `struct` named `DIDDocument`. `doc` is now replaced with the properties of the `struct`.

## `export const getNotifEndpoint = (doc: DidDocument): string | undefined`

This is been converted.

This function has been put into a `struct` named `DIDDocument`. `doc` is now replaced with the properties of the `struct`.

## `export const getServiceEndpoint = (doc: DidDocument, opts: { id: string; type?: string },)`

This has been converted.

This function has been put into a `struct` named `DIDDocument`. `doc` is now replaced with the properties of the `struct`.

## `function findItemById<D extends DidDocument, T extends 'verificationMethod' | 'service',>(doc: D, type: T, id: string): NonNullable<D[T]>[number] | undefined`

This is unneeded and will not be converted.

## `function findItemById(doc: DidDocument, type: 'verificationMethod' | 'service', id: string,)`

This is unneeded and will not be converted.

## `const validateUrl = (urlStr: string): string | undefined`

This has been converted.

## `const canParseUrl`

This is redundant and will not be converted.

Swift can already do this by letting you use `if let _ = URL(string: "[web link]")` or something similar.

## `const verificationMethod`

This has been converted.

## `const service`

This has been converted.

## `export const didDocument`

This has been converted.
