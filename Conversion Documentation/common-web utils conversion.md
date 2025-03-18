#  Conversion for `common-web/utils.ts`

## `export const noUndefinedVals = <T>(obj: Record<string, T | undefined>,): Record<string, T>`

This is mostly redundant.

We can use `compactMapValues` to remove the values.

```swift
var dictionary: [String: Int] = [/* enter key-value pairs here*/] 
dictionary.compactMapValues { $0 }
```

## `export function omit<T extends undefined | null | Record<string, unknown>, K extends keyof NonNullable<T>,>(object: T, rejectedKeys: readonly K[],): T extends undefined ? undefined : T extends null ? null : Omit<T, K>

This is redundant and will not be converted.

## `export function omit(src: undefined | null | Record<string, unknown>, rejectedKeys: readonly string[],): undefined | null | Record<string, unknown>`

This has been converted.

## `export const jitter = (maxMs: number)`

This has been converted.

## `export const wait = (ms: number)`

This is redundant and will not be converted. Instead, use `await Task.sleep()`.

```swift
await Task.sleep(UInt64(14) * 1_000_000_000)
```

## `export type BailableWait`

This is redundant and will not be converted.


## `export const bailableWait = (ms: number): BailableWait`

This is redundant and will not be converted. Instead, use `Task.checkCancellation()`

```swift
let task = Task {
    do {
        for _ in 1...10 {
            try Task.checkCancellation() // Throws if cancelled
            try await Task.sleep(nanoseconds: 1_000_000_000)
        }
        print("Task completed successfully")
    } catch {
        print("Task was cancelled: \(error)")
    }
}

Task {
    try? await Task.sleep(nanoseconds: 3_000_000_000)
    task.cancel()
}
```

## `export const flattenUint8Arrays = (arrs: Uint8Array[]): Uint8Array`

This has been converted.

## `export const streamToBuffer = async (stream: AsyncIterable<Uint8Array>,): Promise<Uint8Array>`

This has been converted.

## `export const s32encode = (i: number): string`

This has been converted.

The constant is converted into an `extension` of `Int`.

## `export const s32decode = (s: string): number`

This has been converted.

The constant is converted into an `extension` of `String`.

## `export const asyncFilter = async <T>(arr: T[], fn: (t: T) => Promise<boolean>,)`

This is redundant and will not be converted. Instead, use `TaskGroup`.

## `export const isErrnoException = (err: unknown,): err is NodeJS.ErrnoException`

This is redundant and will not be converted. Swift should be able to strictly be able to find the property of an error.

## `export const errHasMsg = (err: unknown, msg: string): boolean`

This is redundant and will not be converted. Swift should be able to strictly be able to find out the message.

## `export const chunkArray = <T>(arr: T[], chunkSize: number): T[][]`

This has been converted.

## `export const range = (num: number): number[]`

This is too simple and will not be converted. Use `Array(0..<#)`, where `#` is simply an `Int` value.

## `export const dedupeStrs = (strs: string[]): string[]`

This is too simple and will not be converted. Use `Array(Set([string]))`, where `[string]` is a `String` value.

## `export const parseIntWithFallback = <T>(value: string | undefined, fallback: T,): number | T`

This has been converted.

The constant was converted into an additional initializer for `Int`.
