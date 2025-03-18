#  Conversion for `common-web/arrays.ts`

## `export function keyBy<T, K extends keyof T>(arr: readonly T[], key: K,): Map<T[K], T>`

This is redundant and will not be converted. Instead, use `Dictionary(uniqueKeysWithValues:)`.

## `export const mapDefined = <T, S>(arr: T[], fn: (obj: T) => S | undefined,): S[]`

This is redundant and will not be converted. Instead, use `Array.compactMap(_:)`.
