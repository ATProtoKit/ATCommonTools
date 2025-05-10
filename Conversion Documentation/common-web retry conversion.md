# Conversion for `common-web/retry.ts`

## `export type RetryOptions`

This object has been implemented.

## `export async function retry<T>(fn: () => Promise<T>, opts: RetryOptions & { retryable?: (err: unknown) => boolean } = {},): Promise<T>`

This object has been implemented.

## `export function createRetryable(retryable: (err: unknown) => boolean)`

This object has been implemented.

## `export function backoffMs(n: number, multiplier = 100, max = 1000)`

This object has been implemented.

## `function jitter(value: number)`

This object has been implemented.

## `function randomRange(from: number, to: number)`

This is redundant and will not be converted. Swift has a built in feature that replicates the function, which is also merged with `jitter(value: number)`. 
