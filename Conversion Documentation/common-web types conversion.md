# Conversion for `common-web/types.ts`

## `const cidSchema = z.unknown().transform((obj, ctx): CID`

This is redundant and will not be converted.

MultiformatsKit has an initializer for converting a `Data` or `String` representation of a CID to a `CID` object. Any unknown objects can be easily converted to either one of those types and given to `CID`, whether using `Codable` or the decoing and encoding methods.

## `const carHeader`

This has been converted.

## `export const schema`

This has been converted.

## `export const def`

This has been converted.

## `export type ArrayEl<A> = A extends readonly (infer T)[] ? T : never`

This is redundant and will not be converted. Swift can do this built-in (get an element out of an array).

## `export type NotEmptyArray<T>`

This is unneeded and will not be converted. 
