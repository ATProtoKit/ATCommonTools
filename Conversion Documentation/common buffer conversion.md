# Conversion for `common/buffer.ts`

## `export function ui8ToBuffer(bytes: Uint8Array): Buffer`

This is redundant and will not be converted.

This is the same as converting a `[UInt8]` to a `Data` object. Use `Data([UInt8])` instead.

## `export function ui8ToArrayBuffer(bytes: Uint8Array): ArrayBuffer`

This is not needed and will not be converted.
